# Organizing Shiny Tabs

## Motivation

What are initially thought to be small shiny projects produced for proofs of concept
often outgrow their original intended purpose and become complex code bases. The code
can also be rather unorthodox as newer Shiny developers usually aren't aware of 
established conventions and/or best practices. In this case just understanding 
what the app is supposed to do can be a challenge.

This package aims to take a lot of that decision making out of the hands of the
developer, letting the physical structure of the file system dictate the organization
of the Shiny tabs. While opinionated, this method greatly simplifies code bases
so that the code is much more readable on the UI side.

Standardization is also a key goal -- the code that is written will be
more easily understood by other developers.

## Quick Start

```r
library("shinytabconstructor")
library("shiny")
initTabConstructor()            # initialize the file system conventions
runApp()                        # run the empty app
```

Then,

```r
addTab('help', open = TRUE)             # create a tab and open all associated files
addTab('contact', 'help', open = FALSE) # create a 'child' of the 'help' tab
runApp()                                # see your creation!

deleteTab('help')                       # delete the tab & files
```

## Installation

**NOTE:** To install from source you'll need to [register your SSH keys](http://csmrnd01.infores.com:3000/CSM/register-ssh-keys):

```r
# For Windows only
devtools::install_git("http://csmrnd01.infores.com:3000/CSM-RND/shinytabconstructor.git")
```

I've already installed the package on `csmrnd01`'s system library and on
the mapr03r cluster in my personal library:

```r
.libPaths("/mapr/mapr03r/analytic_users/msmck/usr/local/lib/R")
library("shinytabconstructor")
```

## Walk-Through

#### 1. Create A Project

Create the Shiny Web App project in the usual way:

![Click File > New Project in RStudio](www/init/01-new-proj.png)

![Click 'New Directory'](www/init/02-new-directory.png)

![Choose 'Shiny Web Application'](www/init/03-shiny.png)

![Pick a directory and project name](www/init/04-name.png)

#### 2. Initialize the Framework

We'll need to initialize the framework before we can add any tabs.
It will overwrite the `app.R` file as well as the `ui/` and `server/`
directories. It will ask you multiple times if this is really what you
want to do.

![Load library and initalize](www/init/05-initialize.PNG)

#### 3. Run the App

You're ready to go! The app will run (and be empty). You can run the app by pressing Ctrl + Shift + Enter when focused in the `app.R` script or type:

```r
library("shiny") # if you haven't already
runApp()         # working directory needs to be in the top level of the project
```

Or click:

![Click 'Run App'](www/init/06-run.png)

What it will look like while empty:

![An empty app](www/init/07-empty-app.png)

#### 4. Stop the App

You can stop the app by clicking the Stop button or clicking in the console and hitting `Esc`.

![Hitting Stop](www/init/08-stop-app.png)

#### 5. Create a Tab

Now the fun part. You can use the built in functions to construct tabs.
For instance lets add a `methodology` tab. The names must be valid R object names (alpha-numeric and underscores, with leading letter):

```r
# if no parent is specified, it creates the tab at the top level
addTab("methodology")
```

This will open all of the files that pertain to that tab.

![File Hierarchy](www/app/01-add-meth-tab.PNG)

We've got a folder on the server side, `server/methodology` in which
we've got separate files for the observers, renders and reactives.
This is a mutually exclusive and collectively exhaustive list! If your
solution to your server side problem doesn't fit in these files, you're
asking the _wrong question_.

On the ui side we can see that there is an R script and a .yaml script.
The R script defines the actual structure of the ui whereas the .yaml
signifies to the package that the tab should be included. If there is
a directory with an .R file but no .yaml then it will not be included.
Don't make a habit of this -- if the code is not included in the app then it shouldn't be in that directory!

We've populated some example elements to help you get started:

```r
library("shiny") # if you haven't already
runApp()
```

![app with new tab](www/app/02-meth-tab.PNG)

#### 6. Create Nested Tabs

Here's where the power of `shinytabconstructor` comes in. We'll create some nested tabs and keep the code simple:

```r
# add the 'research' tab under the 'methodology' tab
addTab('research', 'methodology', open = FALSE)

# add the 'white_paper' tab under the 'methodology' tab
addTab('white_paper', 'methodology', open = FALSE)
```

Alright, so what does the app look like now?

![nested tabs in app dir structure](www/app/03-nested-tabs.PNG)

Notice that we have two new server folders with their component pieces. We keep these flat under `server/` because there isn't any hierarchical nature to the server side code.

Notice that on the ui side there _is_ a hierarchical nature. That's
because we use handy recursive programming to construct the menu and
that's how we can represent the structure and keep the code organized
at the same time.

Here's what the app looks like now:

![nested tabs in menu](www/app/04-nested-app.PNG)

But wait, what happened to our `methodology` tab content? Don't worry,
the source code is still there but because of the way the menu is
set up only the leaf levels have content pages.

#### 7. Removing Tabs

Right, so there are a lot of files associated with each tab, part of the price of trying to keep everything organized -- removing a tab seems like a bear. Not to worry, we're here to help. Use the `deleteTab` function (not to be confused with `shiny::removeTab`, a reactive function).

The function is smart and will both ask you to confirm deletion and detect if there are any files (tabs or otherwise) below them.

![deleting a tab recursively](www/app/05-delete-tab.PNG)

Notice the function notified that there were child tabs.

#### 8. Tips

Using RStudio's "Go to file/function" abilities makes moving around
potentially massive apps easy but if you do want more information you
do have access to the utility functions in the app.

**Put code that needs to be run only once or needs to be accessed by both the server and ui in the `app.R`**

#### 9. Enhancements

Right now you don't have a lot of options for customizing the menu in
the sidebar because its automatically created. The .yaml files on the
ui side will be enabled with the functionality to specify everything
you normally would -- I just need to build it out, bear with me.