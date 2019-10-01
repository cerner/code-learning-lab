# Building a pagelet 2019

## Prerequisits to run this project

* [Python][Python] 3.4 or newer installed, and accessible from your PATH.
* Privileges to [update your hosts file][HostFileInstructions]
* Privileges to accept a self-signed certificate for your browser
* Privileges to run commands in a shell or command prompt

## Setup

1. Update /etc/hosts by appending this line:
    ```
    127.0.0.1 localpagelet.test 
    ```

    __Windows users__: follow [these instructions][HostFileInstructions], appending the same line.
 
2. Install dependencies:
    ```
    pip3 install -r requirements.txt 
    ```
    	
    
3. Start the server:
    ```
    sh run.sh
    ```
	
	__Windows users__: Open the `run.bat` file.

	
4. Visit [the pagelet][ThePagelet] in your browser.
5. Accept the self-signed certificate. After you accept it, you'll see a 400 error page. You can close this tab.

## Demo the finished product
Visit [HealtheLife][HealtheLife] in your browser to see the finished pagelet first. Use these credentials:

* Username: `GMansoor01`
* Password: `Cerner01`

[Python]: https://www.python.org/downloads/
[ThePagelet]: https://localpagelet.test:8000/
[HealtheLife]: http://chc2019-pageletclass.patientportal.us.healtheintent.com/
[HostFileInstructions]: https://www.howtogeek.com/howto/27350/beginner-geek-how-to-edit-your-hosts-file/
