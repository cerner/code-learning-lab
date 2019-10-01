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
2. Make a new folder for your project.
2. Download [requirements.txt][] to your project folder.
3. Open a terminal to your project folder (__Windows users__: use cmd.exe).
4. Install the requirements:
    ```
    pip3 install -r requirements.txt 
    ```
    
3. Start the server:
    ```
    env FLASK_ENV=development FLASK_APP=pagelet.py flask run  --port=8000 --cert=cert.crt --key=pkey.key
    ```
    
    __Windows users__: Download [run.bat][] to your project folder, then execute `run.bat` in cmd.exe.

4. Visit [the pagelet][ThePagelet] in your browser.
5. Accept the self-signed certificate. After you accept it, you'll see a 400 error page. You can close this tab.

## Demo the finished product - Procedures widget
Visit [HealtheLife][HealtheLife] in your browser to see the finished pagelet first. Use these credentials:

* Username: `GMansoor01`
* Password: `Cerner01`

The __Procedures widget__ (main column, 2nd from the top) is a pagelet running on your local web server.

![Example Screenshot][]

[Python]: https://www.python.org/downloads/
[ThePagelet]: https://localpagelet.test:8000/
[HealtheLife]: http://chc2019-pageletclass.patientportal.us.healtheintent.com/
[HostFileInstructions]: https://www.howtogeek.com/howto/27350/beginner-geek-how-to-edit-your-hosts-file/
[requirements.txt]: https://raw.githubusercontent.com/cerner/code-learning-lab/master/healthelife/building_pagelets_2019/requirements.txt
[run.bat]: https://raw.githubusercontent.com/cerner/code-learning-lab/master/healthelife/building_pagelets_2019/run.bat
[Example Screenshot]: examples/procedures_screenshot.png 
