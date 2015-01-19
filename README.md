# NPB -- code by coffee-script

Npb is an auxiliary command tool to help developer build node project more convenient.

## Install

    >> (sudo) npm install -g npba

### Update

    >> (sudo) npm update -g npba

## Command

### Helper

* Check Step

    ```
    npb check
    ```

* Show config

    ```
    npb show
    ```

### Step

#### Uninitialized:

    npb.cson not exist

    ```
    npb init
    ```

#### Unsynchronized:

    bower.json or package.json not exist

    ```
    npb sync
    ```

#### Uninstalled:

    bower_components or node_modules not exist

    * Clean

    ```
    npb clean
    npb clean --bower
    npb clean --node
    ```

    * Install

    ```
    npb install
    npb install --bower
    npb install --node
    ```

    * reInstall

    ```
    npb reinstall
    npb reinstall --bower
    npb reinstall --node
    ```
