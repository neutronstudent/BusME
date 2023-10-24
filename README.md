
# BusME

An accesablity application for the AT Transport API built on flutter and ASP.NET


## Deployment

database connection infomation and JWT secrets are stored within the appsettings.json file.
```json
  "ConnectionStrings": {
    "WebApiDatabase": "postgresconnection string"
  },
  "Jwt": // must be the same between instances  {
    "Issuer": "Issuer",
    "Audience": "Audience",
    "Key": "CompleatlyRandomSecretSafeKey" // must be the same between instances
  },

  "api": {
    "key": " At transport api key"
  }
```

To depoly a instance after updating the above file first database migrations must be applied using 
```bash
dotnet ef database update
```

within the BusMEApi folder to setup the appropriate tables on the postgres server.

Then Docker can be used to build a image of the api server within the asp.net webapi folder
 ```bash
 docker build
 ```

 this image can then be used to create instances of the server.

 For deployment of the application, just run the following command within the application folder for the target platform ensuring that dependances are installed 
 
 ```
 flutter build apk
 flutter build ipa
 flutter build ... 
 ```


 for load balancing and seamless redundance a nginx config file is provided, please add any new servers IP addresses to the start of the file and hot-reload the nginx docker container built with the docker-compose file in the services folder, guides can be found on the nginx wiki


