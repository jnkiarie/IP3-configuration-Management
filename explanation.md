### 1. Choice of the base image on which to build each container.  
  - backend-image - This has been created with the mongo-express base image due to the apps use of the mongodb database  
  - client-image - This has been created with the node-alpine base image because the app is built on node platform and the alpine version is light which will make the    built container to be light i.e less megabytes  
    
### 2. Dockerfile directives used in the creation and running of each container.  
   ### backend - Dockerfile  
   
    FROM mongo-express - base image  

    RUN mkdir /backend - create a folder in the container named backend  

    WORKDIR /backend - make the /backend folder the working directory to execute the following commands  

    COPY package-lock.json /backend/ - copy the file to backend so as to guide the npm install on what packages to install  

    COPY package.json /backend/ - copy the file to backend so as to guide the npm install on what packages to install    

    RUN npm install  - install the npm packages as guided by the json files   

    COPY . . - Copy all directories in the base folder on backend to the base folder inside the container   

    CMD ["npm","start"]  - start the app after running the container  
    
###  client-Dockerfile 
    
     FROM node:12-alpine - base image required  

     RUN mkdir /client - create a client directory in the container  

     WORKDIR /client - make the client directory the working directory  

     COPY . . - Copy all files in the base folder to the working directory in the container  

     RUN npm i npm@latest -g - install the latest npm package and make it global  

     RUN npm install - install the npm modules required  

     RUN npm install webpack - install webpack package  

     EXPOSE 3000 - expose port 3000 outside the container  

     CMD ["npm","start"] - run the command after the container is created.   

### 3. Docker-compose Networking (Application port allocation and a bridge network implementation) where necessary.  
    networks:   
    my-network:   
    driver: bridge   

    * Defined a bridge network on docker compose to allow for containers to communicate together  
    * Exposed port 3000 for the localhost to 3000 for the client container so as to communicate with the browser outside the container  
    * Exposed port 5000 for the localhost to 5000 for the client container so as to communicate with the browser outside the container  
    * Docker Images Uploaded : jnkiarie/backend-image:v1.0.0 and jnkiarie/client-image:v1.0.0

### 4. Docker-compose volume definition and usage (where necessary).  

volumes:  
  mongo-volume: - Defined a volume to persist the data incase we delete or exit the container the date will still be available if we run another container afterwards.  

### 5. Git workflow used to achieve the task.  
    * Fork the repository on github  
    * git clone repository from github to local pc  
    * git init - On the parent folder so as to track all files and folders  
    * git add . - to add all the files we create to git repository frequently so as not to have a backlog of code to troubleshoot incase of any errors  
    * git commit -m 'explanation'  
    * git push origin master  