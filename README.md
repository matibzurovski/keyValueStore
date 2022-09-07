# KeyValueStore

A command line interface tool that allows to save key/value pairs on a transactional store.

## Steps to run

There are two options to run this tool:

### Launch from Xcode
You can run and debug the CLI tool from Xcode using the `KeyValueStore` scheme.

### Launch directly from Terminal
An executable file with the last build version can be found under the `Executables` folder. This will run a release version of the tool.

## Available commands
The interface has been extended to support two additional commands, as detailed below:
```
SET <key> <value> // store the value for key
GET <key>         // return the current value for key
DELETE <key>      // remove the entry for key
COUNT <value>     // return the number of keys that have the given value
BEGIN             // start a new transaction
COMMIT            // complete the current transaction
ROLLBACK          // revert to state prior to BEGIN call
EXIT              // finish using KeyValueStore tool
HELP              // display available commands
```
