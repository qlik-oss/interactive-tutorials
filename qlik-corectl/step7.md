
We need to adjust two things when we are changing the data type:

1. The corectl.yml file so that the connection point at the URL where our data is.
We will use the info about the movies  from this [url](https://gist.githubusercontent.com/carlioth/b86ede12e75b5756c9f34c0d65a22bb3/raw/e733b74c7c1c5494669b36893a31de5427b7b4fc/MovieInfo.csv).

2. Change the loadscript so it loads html instead of text.(We always need to change the loadscript when loading different files)

**Exercise:** Change the corectl.yml file so it connects to the url: https://gist.githubusercontent.com/carlioth/b86ede12e75b5756c9f34c0d65a22bb3/raw/e733b74c7c1c5494669b36893a31de5427b7b4fc/MovieInfo.csv

<details> <summary>Show solution</summary>
<p> 

<pre class="file" data-filename="corectl.yml" data-target="replace">
engine: localhost:19076 # URL and port to running Qlik Associative Engine instance
app: myapp   # App name that the tool should open a session against.
script: testscript.qvs # Path to a script that should be set in the app
connections: # Connections that should be created in the app
  webdata: # Name of the connection
    connectionstring: 'https://gist.githubusercontent.com/carlioth/b86ede12e75b5756c9f34c0d65a22bb3/raw/e733b74c7c1c5494669b36893a31de5427b7b4fc/MovieInfo.csv' # Connectionstring (qConnectionString) of the connection. For a folder connector this is an absolute or relative path inside of the engine docker container.
    type: internet # Type of connection
</pre>

</p>
</details>  


Notice that the connection string is the data-URL and that the connection type is internet instead of folder.

Now we make another load script to load from the webdata connection.

**Exercise:** Edit the `testscript.qvs`{{open}} so it loads everything from the `webdata` connection.

<details> <summary>Show solution</summary>
<p> 

<pre class="file" data-filename="testscript.qvs" data-target="replace">
MovieInfo:
LOAD *
FROM [lib://webdata]
(html, utf8, delimiter is ';');

</pre>
The last config line is change from reading text to html!
</p>
</details>  

Now, rebuild the app with `corectl build`{{execute}}.

Analyze the data with the same commands we used before:

`corectl fields`{{execute}} - Displays the fields in the app
<br>

`corectl tables`{{execute}} - Displays tables in the app
<br>

`corectl values <field name>` - Displays the values in the specific field
<br>



