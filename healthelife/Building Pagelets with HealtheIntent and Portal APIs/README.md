# Building a pagelet 2019

## Requirements to run code for this lab

* You can install Python 3 on your laptop
* You can [update your hosts file][HostFileInstructions]
* You can accept a self-signed certificate for your browser
* You can run commands in a shell or command prompt

These might require you have admin or sudo privs.

## Setup

1. Install [Python 3.7 or newer][Python].  
2. After installing, check you are able to run this command in your terminal or command prompt. If successful, that command should return something like 
_Python 3.7.x_:
    ```
    python --version 
    ```

3. Update /etc/hosts by appending this line:
    ```
    127.0.0.1 localpagelet.test 
    ```

    __Windows users__: follow [these instructions][HostFileInstructions], appending the same line.

## Demo - Procedures widget

1. Download the [demo folder][Demo], expand it, and save its contents somewhere.
2. Open a terminal to the demo folder (__Windows users__: use cmd.exe).
4. Install the requirements:
    ```
    pip install -r requirements.txt 
    ```
    
3. Start the server:
    ```
    env FLASK_ENV=development FLASK_APP=pagelet.py flask run  --port=8000 --cert=cert.crt --key=pkey.key
    ```
    
    __Windows users__: Execute `run.bat` in cmd.exe.

4. Visit [the pagelet][ThePagelet] in your browser.
5. Accept the self-signed certificate. After you accept it, you'll see a 400 error page. You can close this tab.
6. Visit [HealtheLife][HealtheLife] in your browser to see the finished pagelet first. Use these credentials:

* Username: `GMansoor01`
* Password: `Cerner01`

The __Procedures widget__ (main column, 2nd from the top) is a pagelet running on your local web server.

![Example Screenshot][]

## Build your own
Now that you've seen the demo, get started building your own version from a skeleton project.

1. Download the [skeleton.zip][Skeleton], expand it, and save its contents somewhere.
2. Open a terminal to the skeleton folder (__Windows users__: use cmd.exe).
3. Install the requirements:
    ```
    pip install -r requirements.txt 
    ```
    
3. Start the server:
    ```
    env FLASK_ENV=development FLASK_APP=pagelet.py flask run  --port=8000 --cert=cert.crt --key=pkey.key
    ```
    
    __Windows users__: Execute `run.bat` in cmd.exe.
4. Follow along with the lab to build it out.

## Running your own
Just like how you ran the demo, just run the commands from your skeleton folder:

1. Start the server:
    ```
    env FLASK_ENV=development FLASK_APP=pagelet.py flask run  --port=8000 --cert=cert.crt --key=pkey.key
    ```
    
    __Windows users__: Execute `run.bat` in cmd.exe.

2. Visit [HealtheLife][HealtheLife].

[Python]: https://www.python.org/downloads/
[ThePagelet]: https://localpagelet.test:8000/
[HealtheLife]: http://chc2019-pageletclass.patientportal.us.healtheintent.com/
[HostFileInstructions]: https://www.howtogeek.com/howto/27350/beginner-geek-how-to-edit-your-hosts-file/
[requirements.txt]: https://raw.githubusercontent.com/cerner/code-learning-lab/main/healthelife/Building%20Pagelets%20with%20HealtheIntent%20and%20Portal%20APIs/demo/requirements.txt
[run.bat]: https://raw.githubusercontent.com/cerner/code-learning-lab/main/healthelife/Building%20Pagelets%20with%20HealtheIntent%20and%20Portal%20APIs/demo/run.bat
[Example Screenshot]: procedures_screenshot.png 
[Demo]: downloads/demo.zip
[Skeleton]: downloads/skeleton.zip
