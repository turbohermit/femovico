# FeMoViCo
**FeMoViCo** is a simple, lightweight and easy-to-use Model-View-Controller framework for GDScript.

I default to Model-View-Controller frameworks when making turn-based games, and this is the implementation I generally fall back on in GDScript.

FeMoViCo stands for:
- **Fe**atures: A Feature is a self-enclosed class that initializes a set of Controllers, similar to a Factory pattern.
- **Mo**dels: A Model is a self-enclosed class containing data. It may only manipulate its own data.
- **Vi**ews: A View is a representation of data, that may also receive user input. It inherits from Node so it can interact with Godot objects.
- **Co**ntrollers: A Controller is a class that executes business logic between Models and Views.

## Features
A **Feature** is a self-enclosed class that initializes a set of Controllers, similar to a factory pattern. They are designed to start or terminate them easily, using _initialize()_ and _terminate()_ respectively.
You can initialize a **Controller** from within a **Feature** by using the _kickstart()_ function. The Feature will automatically track the **Controller** and make sure it's properly terminated when terminating the **Feature**.
Features inherit from **AFeature**, which inherits from Godot's **Resource** class. This is to make it easy to assign any **ModelResources** and **ViewScenes** assets (more on those further down.) 
It also means you have to create an asset for them and reference them somewhere to be able to initialize them. Somewhere like the **FeatureInitializer** for example.

### FeatureInitializer
The FeatureInitializer Node can be placed inside a Scene to launch a set of Features quickly and easily. You can assign a Feature Resource in the exposed StartupFeatures array. It will initialize an _instance_ of each one consecutively.

### Best Practices:
- Should only expose **ModelResources** and **PackedScenes** (for **ViewScenes**).
- Prefer keeping **Features** entirely isolated and self-enclosed.
- However, sometimes it might be necessary to share Models between Features. In that case, you can make a Feature that initializes other Features.

## Models
A **Model** is a self-encapsulated class that may contain game data. It inherits from **AModel**, which inherits from Godot's **RefCounted** class so _should_ automatically be removed from memory when not being used anymore.

### ModelResources
A **ModelResource** inherits from **AModelResource**, which inherits from Godot's **Resource**, so it's useful for serializing pre-made game data, such as configurations, items, units, stats, etc. 
Basically, any static data that's created on disk instead of dynamically at runtime.
You can expose a reference to your custom **ModelResource** in your **Feature**. Then you can create an asset for it and assign it to said **Feature**'s asset.

### Best Practices:
- Host all your game data that you need at runtime in **Models** and nowhere else.
- Should only be accessed by Getters
- Should only be manipulated via functions.

## Views
A **View** is a representation of data, that may also receive user input. It inherits from **AView**, which inherits from Godot's **Node** so it can be placed in an active Scene and interact with other Godot Nodes. 

### ViewScenes
A ViewScene is just a Godot **Scene** that has a **View** as the root node. This makes it easy to create a pre-made hierarchy of Godot Nodes you might need to reference in your view, like Sprites, Meshes, physics stuff, input, etc.
You can expose a reference to a **PackedScene** in your **Feature**. After saving the **Scene** for the ViewScene, you can assign it to said **Feature**'s asset.
(It doesn't have any specific code related to it, it's just a way to refer to the Scene asset of said View.)

## Controllers
A **Controller** is a class that executes business logic between **Models** and **Views**. They are initialized via a **Feature**'s _kickstart()_ function. 
Generally speaking, a Controller should only read data from **Models** using getters and manipulate the data using the Model's exposed functions. 
For **Views**, it should only redirect data from Models to Views using the View's functions.

### Best Practices:
- Controllers should not reference other Controllers. Any communication between Controllers should be done via manipulating Models.
- Controllers should not cache any data in the class body, except for instances/references of **Models**, **Views**, **ModelResources** and **ViewScenes**.

