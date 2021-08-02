imagePath = getDirectory("image");

//	startNucleusSegmentation(imagePath);

if (!File.exists(imagePath))
	image_path=File.openDialog("select image to analyze");  // Select image for analysis
else
	startNucleusSegmentation(imagePath);
	

// --------   Initial function to start the nucleus segmentation ------
function startNucleusSegmentation(img_path) {

	print("\\Clear");

	print("Starting Nucleus Segmentation...\n" + img_path);
	
	// open(img_path);

	setBatchMode(true);
	img_tit=getTitle();

	  /// ------ Create temp director ----------
	  requires("1.35g");
	  // Get path to temp directory
	  tmp = getDirectory("temp");
	  if (tmp=="")
	      exit("No temp directory available");
	 
	  // Create a directory in temp
	  myDir = tmp+"my-test-dir"+File.separator;
	  File.makeDirectory(myDir);
	  if (!File.exists(myDir))
	      exit("Unable to create directory");
	  print(" Creating temporary directory...");
	  print(myDir);

  	/// ------ Create temp director ----------

	downloads_path = getDirectory("downloads");

	directory_path = downloads_path+"nucleus_segmentation_results"+File.separator;

	print("Creating Nucleus_Segmentation_results directory...");

	File.makeDirectory(directory_path);

	if (!File.exists(directory_path)){
	 	// File.makeDirectory(directory_path);
		exit("Unable to create result directory!");
	}

	print(directory_path);
	
	file_path = directory_path +img_tit+"_";
	filename = file_path+ "nuclues_segmentaion_result.csv";

	num = 1;

	while (File.exists(filename)) {
	    filename = file_path+ "nuclues_segmentaion_result"+ num++ +".csv";
	 }
	print(filename);  
	
	
	// find nucleus and setting 3D OC options 
	run("3D OC Options", "obj volume surface nb_of_obj._voxels nb_of_surf._voxels integrated_density mean_gray_value std_dev_gray_value median_gray_value minimum_gray_value maximum_gray_value centroid mean_distance_to_surface std_dev_distance_to_surface median_distance_to_surface centre_of_mass bounding_box close_original_images_while_processing_(saves_memory) dots_size=5 font_size=10 store_results_within_a_table_named_after_the_image_(macro_friendly) redirect_to=none");
	find_3D_NUCLEUS(img_path,img_tit);
	//	selectWindow("Objects map of "+"Nucleus of "+img_tit);
	number_of_nucleus=Stack.getStatistics(area, mean, min, max);
	rename("Nucleus of - " +img_tit);
	nucleus_object_IMG_tit="Nucleus of - " +img_tit;
	// extract nucleolus per nucleus
	selectWindow(nucleus_object_IMG_tit);

	number_of_nucleus=max+1;
	print("number of nucleus: " + number_of_nucleus);
	
	title = "Nucleolus Parameters";
	  	width=512; height=512;
		Dialog.create("Nucleolus Parameters");
		  Dialog.addString("Gaussian Blur:", 1);
		  Dialog.addString("Subtract Background:", 50);
		  Dialog.addString("Subtract:", 90);
		  Dialog.addString("3D Simple Segmentation Threshold:", 10);
		  Dialog.addString("3D Simple Segmentation Min:", 0);
		  Dialog.addString("3D Simple Segmentation Max:", -1);
		  Dialog.show();
   
	  GaussianBlur1 = Dialog.getString();
	  SubtractBackground1 = Dialog.getString();
	  Subtract1 = Dialog.getString();
	  SimpleSegmentationThreshold1 = Dialog.getString();
	  SimpleSegmentationMin1 = Dialog.getString();
	  SimpleSegmentationMax1 = Dialog.getString();


  	run("Read and Write Excel", "file=["+filename+"] file_mode=read_and_open");	

	for (n = 1; n < number_of_nucleus; n++) {
		print("-------------------------------------");		
		print("Find number of Nucleuolus in NUCLUES object " + n);		
		nucleolus_per_nucleus(nucleus_object_IMG_tit,img_tit,n);
		selectWindow("imgDUP");	
		nucleuolus_tit="Nucleuolus of NUC " + n +" - " +img_tit;
		rename(nucleuolus_tit);
		selectWindow(nucleuolus_tit);
		
		find_3D_NUCLEOLUS(img_path,nucleuolus_tit);	


		selectWindow("Statistics for Nucleuolus of NUC "+n+ " - "+img_tit);

		tableTitle = Table.title;
		Table.rename(tableTitle, "Results"); 
		
		run("Read and Write Excel", "stack_results sheet=["+ nucleuolus_tit +"]  file_mode=queue_write");

		close(nucleuolus_tit);
		close("Statistics for Nucleuolus of NUC "+n+ " - "+img_tit);	
		close("Object*");
		close("Results");
	}
	
	run("Read and Write Excel", "file_mode=write_and_close");

	// open(filename);

	IJ.log("FINISH!");
	setBatchMode(false);
	



//////////////////////////////////////////////

  	title = "Nucleolus Parameters 1";
		    width=512; height=512;
			Dialog.create(title);
			  Dialog.addString("Gaussian Blur:", 1);
			  Dialog.addString("Subtract Background:", 50);
			  Dialog.addString("Subtract:", 90);
			  Dialog.addString("3D Simple Segmentation Threshold:", 10);
			  Dialog.addString("3D Simple Segmentation Min:", 0);
			  Dialog.addString("3D Simple Segmentation Max:", -1);
			  Dialog.show();
		   
		  GaussianBlur1 = Dialog.getString();
		  SubtractBackground1 = Dialog.getString();
		  Subtract1 = Dialog.getString();
		  SimpleSegmentationThreshold1 = Dialog.getString();
		  SimpleSegmentationMin1 = Dialog.getString();
		  SimpleSegmentationMax1 = Dialog.getString();
		  
	selectWindow(img_tit);
	run("Duplicate...", "duplicate");
	run("Gaussian Blur...", "sigma=GaussianBlur1 stack");
	run("Subtract Background...", "rolling=SubtractBackground1 stack");
	run("HiLo");
	run("Subtract...", "value=Subtract1 stack");
	run("3D Simple Segmentation", "low_threshold=SimpleSegmentationThreshold1 min_size=SimpleSegmentationMin1 max_size=SimpleSegmentationMax1");
	run("3-3-2 RGB");

	selectWindow("Seg");
	rename("3D Simple Segmentation1");
	run("3D Objects Counter", "threshold=1 slice=1 min.=1 max.=4325376 objects statistics summary");
	run("3-3-2 RGB");
	run("3D Manager");
	
	Ext.Manager3D_AddImage();
	Ext.Manager3D_SelectAll();
	Ext.Manager3D_Label();
	Ext.Manager3D_Close();

	selectWindow("Statistics for 3D Simple Segmentation1");

	tableTitle = Table.title;
	Table.rename(tableTitle, "Results"); 

	print("Appending result in file...");
	print(filename);
	
	run("Read and Write Excel", "file=["+filename+"] file_mode=read_and_open");
	run("Read and Write Excel", "stack_results sheet=[3D Manager Measure1]  file_mode=queue_write");	
	run("Read and Write Excel", "file_mode=queue_write");
	run("Read and Write Excel", "file_mode=write_and_close");

	close("Results");
		
	//	Ext.Manager3D_Count(nb_obj); 
	//	print("");
	//	print("Running Manager3D_Measure1 on "+nb_obj+" objects... please wait for a moment!");
	//
	//	Ext.Manager3D_Measure();
	//	Ext.Manager3D_SaveResult("M",myDir+"Nucleolus3DResultsMeasure1.csv");
	//	Ext.Manager3D_CloseResult("M");
	//	Ext.Manager3D_Close();

	// saveAs("Nucleolus3DResultsMeasure1.csv");
	
	// selectWindow("Objects map of Seg");
	saveAs("tiff", myDir+"1.tif");
	close("tempDUP");
	close("Bin");


	title = "Nucleolus Parameters 1";
		    width=512; height=512;
			Dialog.create(title);
			  Dialog.addString("Gaussian Blur:", 1);
			  Dialog.addString("Subtract Background:", 50);
			  Dialog.addString("Subtract:", 90);
			  Dialog.addString("3D Simple Segmentation Threshold:", 10);
			  Dialog.addString("3D Simple Segmentation Min:", 0);
			  Dialog.addString("3D Simple Segmentation Max:", -1);
			  Dialog.show();
		   
		  GaussianBlur2 = Dialog.getString();
		  SubtractBackground2 = Dialog.getString();
		  Subtract2 = Dialog.getString();
		  SimpleSegmentationThreshold2 = Dialog.getString();
		  SimpleSegmentationMin2 = Dialog.getString();
		  SimpleSegmentationMax2 = Dialog.getString();

	selectWindow(img_tit);
	run("Duplicate...", "duplicate");
	run("Gaussian Blur...", "sigma=GaussianBlur2 stack");
	run("Subtract Background...", "rolling=SubtractBackground2 stack");
	run("HiLo");
	run("Subtract...", "value=Subtract2 stack");
	run("3D Simple Segmentation", "low_threshold=SimpleSegmentationThreshold2 min_size=SimpleSegmentationMin2 max_size=SimpleSegmentationMax2");
	run("3-3-2 RGB");
	selectWindow("Seg");
	rename("3D Simple Segmentation2");
	run("3D Objects Counter", "threshold=1 slice=1 min.=1 max.=4325376 objects statistics summary");
	run("3-3-2 RGB");
	run("3D Manager");
	Ext.Manager3D_SelectAll();
	Ext.Manager3D_AddImage();
	Ext.Manager3D_SelectAll();
	Ext.Manager3D_Label();

	selectWindow("Statistics for 3D Simple Segmentation2");

	tableTitle = Table.title;
	Table.rename(tableTitle, "Results"); 

	print("Appending result in file...");
	print(filename);
	
	run("Read and Write Excel", "file=["+filename+"] file_mode=read_and_open");
	run("Read and Write Excel", "stack_results sheet=[3D Manager Measure2]  file_mode=queue_write");	
	run("Read and Write Excel", "file_mode=queue_write");
	run("Read and Write Excel", "file_mode=write_and_close");

	close("Results");
	
	//	Ext.Manager3D_Count(nb_obj); 
	//	print("");
	//	print("Running Manager3D_Measure1 on "+nb_obj+" objects... please wait for a moment!");
	//	Ext.Manager3D_SaveResult("M",myDir+"Nucleolus3DResultsMeasure2.csv");
	//	Ext.Manager3D_CloseResult("M");
	//	Ext.Manager3D_Close();
	
	saveAs("tiff", myDir+"2.tif");
	close("tempDUP");
	close("Bin");
	

	open(myDir+"1.tif");
	selectWindow("1.tif");
	run("8-bit");
	open(myDir+"2.tif");
	selectWindow("2.tif");
	run("8-bit");
	selectWindow(img_tit);
	run("8-bit");
	run("Merge Channels...", "c1=1.tif c2="+img_tit+" c3=2.tif create");

	
// -- INFORM USER ABOUT THE RESULT LOCATION FOR ANALYSIS ------

waitForUser("Overall nucleus segmentation results are saved in following directory: \n" + "' "+ filename +" '");

/////////////////////

// --- Clear temporary directory ---------------

list = getFileList(myDir);
	for (i=0; i<list.length; i++)
	    print(list[i]+": "+File.length(myDir+list[i])+"  "+File. dateLastModified(myDir+list[i]));
	
	// Delete the files and the directory
	for (i=0; i<list.length; i++)
	     ok = File.delete(myDir+list[i]);
	ok = File.delete(myDir);
	if (File.exists(myDir))
	    exit("Unable to delete directory");
	else
	    print("Temporary directory and files successfully deleted");


}

// ----------------- Function for finding nuclues -----------------

function find_3D_NUCLEUS(img_path,img_tit){
	title = "Nucleus Parameters";
	  width=512; height=512;
	Dialog.create("Nucleus Parameters");
	  Dialog.addString("Gaussian Blur:", 3);
	  Dialog.addString("Subtract Background:", 50);
	  Dialog.addString("Subtract:", 10);
	  Dialog.addString("3D Simple Segmentation Threshold:", 10);
	  Dialog.addString("3D Simple Segmentation Min:", 0);
	  Dialog.addString("3D Simple Segmentation Max:", -1);
	  Dialog.show();
   
	  GaussianBlur = Dialog.getString();
	  SubtractBackground = Dialog.getString();
	  Subtract = Dialog.getString();
	  SimpleSegmentationThreshold = Dialog.getString();
	  SimpleSegmentationMin = Dialog.getString();
	  SimpleSegmentationMax = Dialog.getString();

	run("Duplicate...", "title=imgDUPLICATE duplicate");
	run("Gaussian Blur...", "sigma=GaussianBlur stack");
	run("Subtract Background...", "rolling=SubtractBackground stack");
	run("HiLo");
	run("Subtract...", "value=Subtract stack");
	run("3D Simple Segmentation", "low_threshold=SimpleSegmentationThreshold min_size=SimpleSegmentationMin max_size=SimpleSegmentationMax");
	run("3-3-2 RGB");
	
	selectWindow("Seg");
	Seg_title = "Nucleus segmentation of "+img_tit;
	
	rename(Seg_title);
	
	run("3D Objects Counter", "threshold=1 slice=1 min.=1000 max.=4325376 objects statistics summary");
	
	run("3-3-2 RGB");
	
	windowname = "Statistics for "+ Seg_title;
	
	selectWindow(windowname);
	
	tableTitle = Table.title;
	Table.rename(tableTitle, "Results"); 
	
	run("Read and Write Excel", "file=["+filename+"] sheet=[3D NUCLUES SEG] file_mode=read_and_open");	
	run("Read and Write Excel", "file_mode=queue_write");
	run("Read and Write Excel", "file_mode=write_and_close");
	
	close("Nucleus of "+img_tit);
	close("Bin");
	close("imgDUPLICATE");
	close("Results");


}

// ----------- Find Nucleolus per nucleus ----------------------------

function find_3D_NUCLEOLUS(img_path,img_tit){
	run("Duplicate...", "title=tempDUP_NUCLEOLUS duplicate");
	selectWindow("tempDUP_NUCLEOLUS");
	run("Gaussian Blur...", "sigma=GaussianBlur1 stack");
	run("Subtract Background...", "rolling=SubtractBackground1 stack");
	run("HiLo");
	run("Subtract...", "value=Subtract1 stack");
	run("3D Simple Segmentation", "low_threshold=SimpleSegmentationThreshold1 min_size=SimpleSegmentationMin1 max_size=SimpleSegmentationMax1");
	run("3-3-2 RGB");
	selectWindow("Seg");
	rename(img_tit);
	run("3D Objects Counter", "threshold=1 slice=1 min.=1 max.=4325376 objects statistics summary");
	close(img_tit);
	run("3-3-2 RGB");
	close("Seg");
	close("Bin");
	close("tempDUP_NUCLEOLUS");
}


// ----------- Function for finding nucleolus ----------------------

function nucleolus_per_nucleus(nucleus_object_IMG_tit,img_tit,n){
	resetThreshold;
	setOption("BlackBackground", true);
	selectWindow(nucleus_object_IMG_tit);
	run("Duplicate...", "title=tempDUP_NUCL duplicate");
	setThreshold(n, n);
	run("Convert to Mask", "method=Default background=Dark black");
	
	selectWindow(img_tit);
	run("Duplicate...", "title=imgDUP duplicate");
	selectWindow("imgDUP");
	
	imageCalculator("AND stack", "imgDUP","tempDUP_NUCL");
	
	selectWindow("imgDUP");	
	close("tempDUP_NUCL");
}
