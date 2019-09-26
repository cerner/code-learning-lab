# Building a pagelet 2019

## Prerequisits to run this project

* [Python][Python] 3.4 or newer installed
* Privileges to [update your hosts file][HostFileInstructions]
* Privileges to accept a self-signed certificate for your browser
* Privileges to run commands in a shell or command prompt

## Setup

1. Update your host file.
    ```
    # macOS or *nix users:
    sudo sh update_hosts.sh
    ```

    __Windows users__: follow [these instructions][HostFileInstructions], pasting in the contents of this project's `hosts` file.
 
2. Install dependencies:
    ```
    pip install -r requirements.txt 
    ```
3. Start the server:
    ```
    sh run.sh
    ```
4. Visit [the pagelet][ThePagelet] in your browser.
5. Accept the self-signed certificate.

## Demo the finished product
Visit [HealtheLife][HealtheLife] in your browser to see the finished pagelet first. Use these credentials:

* Username: `GMansoor01`
* Password: `Cerner01`

[Python]: https://www.python.org/downloads/
[ThePagelet]: https://localpagelet.test:8000/
[HealtheLife]: http://chc2019-pageletclass.patientportal.us.healtheintent.com/
[HostFileInstructions]: https://www.howtogeek.com/howto/27350/beginner-geek-how-to-edit-your-hosts-file/
