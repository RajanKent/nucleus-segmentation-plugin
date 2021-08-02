# Nucleus Segmentation : Automate multichannel fluorescence analysis

This is an nucleus-segmentation-plugin project to Automate multichannel fluorescence analysis - Nucleus Segmentation.

A final project report submitted to ** Kent State University ** in partial fulfilment of the requirement for the degree of **Master of Science in Computer Science**


### Nucleus segmentation

Nucleus segmentation is a fundamental task in microscopy image analysis based on which multiple biological related analysis can be performed. 

Cell or cell nuclei segmentation is typically the first critical step for biomedical microscopy image analysis. On the basis of accurate cell or cell nuclei segmentation, multiple biological or medical analysis can be performed subsequently, including cell type classification, particular cell counting, cell phenotype analysis etc., providing valuable diagnostic information for doctors and researchers. Although conventional image processing techniques are still employed for this time and labor consuming task, they often cannot achieve the optimized performance due to multiple reasons, such as limited capability of dealing with diverse images.

For automating these multichannel image analysis we are using ImageJ image progressing. Specifically we are using the Fiji app (image processing package - distribution of ImageJ2). We can build plugins which facilitate scientific image analysis.

For this project we have developed a plugin to automate the nucleus segmentation with provided image test dataset.

#### Purpose

From this plugin we can get the statistics of the number of nucleus objects and the number of nucleolus present within the nucleus objects with various details about the volume, size, distance etc. And the final stat can be saved in csv format.


#### Run Nucleus segmentation plugin / macro


#### Prerequisites:

Download the latest Fiji Application with ImageJ2
[Download link](https://imagej.net/software/fiji/downloads)

Check this update sites:

```
Help > Update > Manage update sites > 
```

##### Check these sites
-  ImageJ
- Fiji
- Java-8
- 3D ImageJ Suite
- Big-EPFL
- ResultsToExcel


#### How it works:

- We can use this project as plugin or macro
- As plugin we are packaging macro with in a jar file and running it using script service


#### Steps:

1. Select the image dataset
2. Input the the necessary parameters for segmentation
3. And analyze final composed image and statistics in the result
4. Overall segmented result are saved in csv format in following location;

> Downloads>”nucleus_segmentation_results” folder image filename

> Example: c.tif_nuclues_segmentaion_result2.csv


###  How to run with jar file:

1. Download the jar file into the jars folder or plugin folder within your Fiji app

2. Restart application and the plugin should be available in “Plugin tab”

	Navigate > Plugins and scroll down “NucleusSegmentation” should be there

3. Then we can select the image dataset and click on “NucleusSegmentation” . It should start the image processing with necessary input dialogs and logs.



To Get Started making changes in this repository
===========================================

1. Visit [this link](https://github.com/RajanKent/nucleus-segmentation-plugin.git)
   to create a new repository in your space using this one as a template.

2. [Clone your new repository](https://help.github.com/en/articles/cloning-a-repository).

3. Edit the `pom.xml` file. Every entry should be pretty self-explanatory.
   In particular, change
    1. the *artifactId* (will be used for the JAR file name prefix)
    2. the *groupId*, ideally to a reverse domain name your organization owns
    3. the *version* (note that you typically want to use a version number
       ending in *-SNAPSHOT* to mark it as a work in progress rather than a
       final version)
    4. the *dependencies* (read how to specify the correct
       *groupId/artifactId/version* triplet
       [here](https://imagej.net/Maven#How_to_find_a_dependency.27s_groupId.2FartifactId.2Fversion_.28GAV.29.3F))
    5. the *developer* information
    6. the *scm* information

3. Add your own `.java` files to `src/main/java/<package>/` (if you need supporting files such as icons
   in the resulting `.jar` file, put them into `src/main/resources/`)

4. Replace the contents of `README.md` with information about your project.

5. Make your initial
   [commit](https://help.github.com/en/desktop/contributing-to-projects/committing-and-reviewing-changes-to-your-project) and
   [push the results](https://help.github.com/en/articles/pushing-commits-to-a-remote-repository)!

### Eclipse: To ensure that Maven copies the plugin to your ImageJ folder

1. Go to _Run Configurations..._
2. Choose _Maven Build_
3. Add the following parameter:
    - name: `scijava.app.directory`
    - value: `/path/to/ImageJ.app/`

This ensures that the final `.jar` file will also be copied to
your ImageJ plugins folder everytime you run the Maven build.

