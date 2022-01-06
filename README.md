# Online Survey Rack App

The app display a **survey form** for users to use and a **report** page for admins to check the results.

### Survey Form
It will show errors to user if invalid input is submitted such as empty params or invalid email.

Once submitted, it **sets a cookie** to remember. 
To avoid abuse, it also sends an email to user to confirm the validity of their email.

To gather data, it is using **CSV** file for the survey answers and a **JSON** file for emails validation process.

![image](https://user-images.githubusercontent.com/85266997/148327463-7a53f8cc-bce4-4181-9e6a-66872017afd4.png)


### Survey Report
For the survey report, the app use **HTTP Basic Authentification** to access it. The admins will just need to type the username and password.

It will only show the survey results from validated emails. If the email has not been validated, it will not be included in the report.

The report is displayed in a pie chart format for each survey questions with only one line of code such as ``` <%= pie_chart(data) %> ``` thanks to the **Chartkick** gem. 

![image](https://user-images.githubusercontent.com/85266997/148321228-d123803d-32e0-42af-8aaf-c53d959dc18c.png)


## Usage

From the project directory, use the command line and run ``` rackup config.ru ``` in order to start the server.

Choose your preferred browser and go the url `http://localhost:9292` .

You might need ruby 2.7.5 to run it.

### Tests

To run the tests : `ruby test\{test_file_name}.rb`

There is 6 tests files test :

`app_integration_test.rb`

`admin_test.rb`

`email_test.rb`

`survey_test.rb`

`template_test.rb`

`route_test.rb`

## Live Demo
  
![image](https://user-images.githubusercontent.com/85266997/148331200-e1177573-18af-4462-aa07-6d5c435e74ba.png)

[Video Link](https://oc-visio-archive.s3.eu-west-1.amazonaws.com/46969134/fe11697a-daca-44f7-9b8d-2191d5ef6d6f/archive.mp4?X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJ3OEUN7A5K7BWS3Q%2F20220106%2Feu-west-1%2Fs3%2Faws4_request&X-Amz-Date=20220106T050021Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Signature=b3371b4cb902715d41c93eb6888c4ce9e088d1ba8b80b742becc59efb3f2b860)

Presentation made to project assessor @amuntasim , a senior software engineer and mentor at Openclassrooms (https://amuntasim.github.io/).

