# Secure Authenticator

<br>

#### This was built to provides a safe method of storing API keys locally (encrypted) yet retaining the ability to reference the values held inside of other scripts. You must overwrite the existing API_DB but keep the same name for your own API Database. If you decide not to use apisee to create new items within the database, you must be sure to conform to the structure of a CSV file, I would suggest avoiding manual edits if possible and rely on the existing methods for updating values via apisee, as regex will ensure data has been properly formatted before adding it to the database.

<br>

#### Must be run with newest version of OpenSSL & Bash Version > 4.0. I suggest using homebrew to install newest Bash version if using via Mac OS.

<br>

#### Usage: The -h switch when executing either of the tools (apisee or auth) will provide examples and context for their use.
