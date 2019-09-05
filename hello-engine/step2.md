
We have prepared a file for you **open the file:** `app.js`{{open}} to check it out. The code is not finish follow the five steps to complete to create and app that communicates with engine.

#### Require
At the top file we see three require, theese includes nodejs modules into our project from remote files. If you are curious read more about [require].(https://nodejs.org/en/knowledge/getting-started/what-is-require/)
![import](hello-engine/assets/Imports.png) 
#### Async/Await
In our case `async` might be unessecary since we will be running the engine on a localhost. But if you are running a engine against a remote host `async/await` will be necessary.  

## Enigma.js
In this tutorial we will use [enigma.js](https://github.com/qlik-oss/enigma.js) which is a library that helps you communicate with Qlik QIX Engine. You can use enigma.js to build your own browser-based analytics tools, back-end services, or command-line scripts.

To find all solutions in this tutorial look at the [enigma.js API documentation](https://github.com/qlik-oss/enigma.js/blob/master/docs/api.md#api-documentation).

#### 1. Configure enigma.create()
To create a session you will have to use `enigma.create()`.<br> 
Enigma create uses a configuration object, create a configuration object with the: <br>**websocket URL**: `'ws://localhost:9076/app/engineData'` and the: <br> **schema**: `enigma.js/schemas/3.2.json` (Look at the  `const schema`).

<details> <summary>enigma.create() solution</summary>
<p> 
<pre class="file" data-target="clipboard"> enigma.create({ 
      schema,
      url: 'ws://localhost:19076/app',
      createSocket: url => new WebSocket(url)
  });
</pre>
</p>
</details>  
<br>


#### 2. Open a session

After you have created a session object, open the session! 
<details>
<summary>Show solution</summary>
<p>
<pre class="file" data-target="clipboard">
const global = await session.open();
</pre>
</p>
</details>  
<br>

#### 3. Retrieve the session version

With an open session we can retieve the version of the session!

 <details>
<summary>Show solution</summary>
<p>
<pre class="file" data-target="clipboard">
 const version = await global.engineVersion();
</pre>
</p>
</details>  
<br>


#### 4. Close the session

When were are done communicating with engine close the session!

 <details>
<summary>Show sultion</summary>
<pre class="file" data-target="clipboard">await session.close();</pre>
</details>  
<br>


#### 5. Run the app

 We now have an application the will:
 1. Create and open session against engine
 2. Retrive the version of the engine
 3. Write the engines version in the console window
 4. Close the session



   
Run the code: <br>
`npm run start`{{execute}}


