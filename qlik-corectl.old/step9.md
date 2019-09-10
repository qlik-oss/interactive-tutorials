This step will handle loading objects into to you app. Objects is the core of Qlik data visualization and if you are unfamiliar with objects, we recommend you to read about [qlik-objects](http://help.qlik.com/en-US/sense-developer/June2019/SubSystems/Platform/Content/Sense_PlatformOverview/Concepts/GenericObject.htm).

### Objects

`corectl-object.json`{{open}} is a very stripped object that will fetch year and movie from the first five movies in the movie table.

Change the `corectl.yml` so it creates the `corectl-object.json` 


<details> <summary>Show solution</summary>
<p> 
<pre class="file" data-filename="corectl.yml" data-target="append">
objects:
  - ./corectl-object.json # Path to objects that should be created from a json file. Accepts wildcards.
</pre>
</p>
</details>  
<br>
Maybe you have missed a step or made a typo, here is the
<details> <summary>finished corectl.yml file</summary>
<p> 
<pre class="file" data-filename="corectl.yml" data-target="replace">
engine: localhost:19076 # URL and port to running Qlik Associative Engine instance
app: myapp   # App name that the tool should open a session against.
script: testscript.qvs # Path to a script that should be set in the app
connections: # Connections that should be created in the app
  testdata:
      connectionstring: /data # Connectionstring (qConnectionString) of the connection. For a folder connector this is an absolute or relative path inside of the engine docker container.
      type: folder # Type of connection
  webdata: 
      connectionstring: 'https://gist.githubusercontent.com/carlioth/b86ede12e75b5756c9f34c0d65a22bb3/raw/e733b74c7c1c5494669b36893a31de5427b7b4fc/MovieInfo.csv'
      type: internet 
objects:
  - ./corectl-object.json # Path to objects that should be created from a json file. Accepts wildcards.

</pre>
</details>

<br>

We have now structured our data with an object. Lets see how the object is used within the app. First run `corectl build`{{execute}}
<br>

Run the `corectl object`{{execute}} to se which cli commands we can use.
<br>

Let's check our apps with `corectl object ls`{{execute}}
<br>

Then we can see what data we fetch by:
`corectl object data MyObject`{{execute}}
<br>
This seem to be correct since our initial data fetch in the `corectl-object.json`{{open}} was 5 movies.

`corectl object properties MyObject`{{execute}} - Displays the properties of the object.
<br>

`corectl object layout MyObject`{{execute}} - Display the layout. Which is the entire object with the data included (this is the object you use when want to get your data into visualization models).

<br> 

## Using corectl and javascript

When looking at the layout object we can see that our 5 movies is stored in qHyperCube -> qDataPages -> qMatrix
We could actually use this path from the layout to print the movies in a javascript file. For example by re-write the app used in the [load data core tutorial](https://github.com/qlik-oss/core-get-started/blob/master/src/hello-data/hello-data.js) to load the settings from corectl.
<br>

First create a javascript file: `touch app.js`{{execute}}
<br>

**Exercise** Open `app.js`{{open}} and copy the code from the gitHub repo. 
Then re-write the code so it opens our app and our objective instead. 
Last print the information in `layout.qHyperCube.qDataPages[0].qMatrix`.


<details> <summary>Show solution</summary>
<p> 

<pre class="file" data-filename="app.js" data-target="replace">
/* eslint no-console:0 */
const WebSocket = require('ws');
const enigma = require('enigma.js');
const schema = require('enigma.js/schemas/3.2.json');

(async () => {
  try {
    console.log('Setting up session.');
    const session = enigma.create({
      schema,
      url: 'ws://localhost:19076/app/',
      createSocket: url => new WebSocket(url),
    });
  
    const qix = await session.open();
    
    // Add 'myapp' to the session
    const app = await qix.openDoc('myapp');
    
    // Include the object in the app
    const object = await app.getObject('MyObject');
    
    // Return layout of the object
    const layout = await object.getLayout();

    // Fetch the data from the hypercube 
    const movies = layout.qHyperCube.qDataPages[0].qMatrix; 

    console.log('Listing the movies:');
    movies.forEach((movie) => { console.log(movie[0].qText); });

    await session.close();
    console.log('Session closed.');
  } catch (err) {
    console.log('Whoops! An error occurred.', err);
    process.exit(1);
  }
})();
</pre>

</details>
</p> 

To run this script use:`npm run print-movies`{{execute}}
<br>

And the five movies should be printed!


