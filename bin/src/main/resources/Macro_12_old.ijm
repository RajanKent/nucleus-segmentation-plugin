img_path=File.openDialog("select image to analyze"); //select image to open


processNucleus(img_path);


function processNucleus(img_path) {
	open(img_path);

	setBatchMode(true);
	img_tit=getTitle();
	
	// find nucleus and setting 3D OC options 
	run("3D OC Options", "volume surface nb_of_obj._voxels nb_of_surf._voxels integrated_density mean_gray_value std_dev_gray_value median_gray_value minimum_gray_value maximum_gray_value centroid mean_distance_to_surface std_dev_distance_to_surface median_distance_to_surface centre_of_mass bounding_box close_original_images_while_processing_(saves_memory) dots_size=5 font_size=10 store_results_within_a_table_named_after_the_image_(macro_friendly) redirect_to=none");
	
	find_3D_NUCLEUS(img_path,img_tit);
	
	selectWindow("Objects map of "+"Nucleus of "+img_tit);
	number_of_nucleus=Stack.getStatistics(area, mean, min, max);
	
	rename("Nucleus of - " +img_tit);
	
	nucleus_object_IMG_tit="Nucleus of - " +img_tit;
	
	// extract nucleolus per nucleus
	selectWindow(nucleus_object_IMG_tit);
	
	number_of_nucleus=max+1;
	
	print("number of nucleus");
	print(number_of_nucleus);
	
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
   
  GaussianBlur = Dialog.getString();
  SubtractBackground = Dialog.getString();
  Subtract = Dialog.getString();
  SimpleSegmentationThreshold = Dialog.getString();
  SimpleSegmentationMin = Dialog.getString();
  SimpleSegmentationMax = Dialog.getString();
  
	for (n = 1; n < number_of_nucleus; n++) {
		print(n);		
		nucleolus_per_nucleus(nucleus_object_IMG_tit,img_tit,n);
		selectWindow("imgDUP");	
		nucleuolus_tit="Nucleuolus of NUC " + n +" - " +img_tit;
		rename(nucleuolus_tit);
		selectWindow(nucleuolus_tit);
		
		find_3D_NUCLEOLUS(img_path,nucleuolus_tit);	
		//waitForUser("ciao","ciao");
		close(nucleuolus_tit);
		close("Object*");
	}
	//selectWindow(img_tit);
	IJ.log("FINISH!");
	setBatchMode(false);
	
////////////////////////////////////////////


selectWindow("c.tif");
run("Duplicate...", "duplicate");
run("Gaussian Blur...", "sigma=3 stack");
run("Subtract Background...", "rolling=50 stack");
run("HiLo");
run("Subtract...", "value=10 stack");
run("3D Simple Segmentation", "low_threshold=10 min_size=0 max_size=-1");
run("3-3-2 RGB");

selectWindow("Seg");
run("3D Objects Counter", "threshold=1 slice=1 min.=1 max.=4325376 objects statistics summary");
run("3-3-2 RGB");
run("3D Manager");
Ext.Manager3D_AddImage();
Ext.Manager3D_SelectAll();
Ext.Manager3D_Label();

selectWindow("Objects map of Seg");
File.makeDirectory("/Users/rajanmaharjan/Downloads/nuclues_working_director");
saveAs("Tiff", "/Users/rajanmaharjan/Downloads/nuclues_working_director/1.tif");

// close();
// close();
// close();
// close();

selectWindow("c.tif");
run("Duplicate...", "duplicate");
run("Gaussian Blur...", "sigma=1 stack");
run("Subtract Background...", "rolling=50 stack");
run("HiLo");
run("Subtract...", "value=100 stack");
run("3D Simple Segmentation", "low_threshold=10 min_size=0 max_size=-1");
run("3-3-2 RGB");
run("3D Objects Counter", "threshold=1 slice=1 min.=1 max.=4325376 objects statistics summary");
run("3-3-2 RGB");
run("3D Manager");
Ext.Manager3D_SelectAll();
Ext.Manager3D_AddImage();
Ext.Manager3D_SelectAll();
Ext.Manager3D_Label();
selectWindow("Objects map of Seg");
saveAs("Tiff", "/Users/rajanmaharjan/Downloads/nuclues_working_director/2.tif");
// close();
// close();
// close();



open("/Users/rajanmaharjan/Downloads/nuclues_working_director/1.tif");
open("/Users/rajanmaharjan/Downloads/nuclues_working_director/2.tif");
selectWindow("c.tif");
run("8-bit");
run("Merge Channels...", "c1=1.tif c2=c.tif c3=2.tif create");


///////

}

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

	run("Duplicate...", "title=imgDUP duplicate");
	run("Gaussian Blur...", "sigma=GaussianBlur stack");
	run("Subtract Background...", "rolling=SubtractBackground stack");
	run("HiLo");
	run("Subtract...", "value=Subtract stack");
	run("3D Simple Segmentation", "low_threshold=SimpleSegmentationThreshold min_size=SimpleSegmentationMin max_size=SimpleSegmentationMax");
	run("3-3-2 RGB");
	
	selectWindow("Seg");
	rename("Nucleus of "+img_tit);
	run("3D Objects Counter", "threshold=1 slice=1 min.=1000 max.=4325376 objects statistics summary");
	
	run("3-3-2 RGB");
	close("Nucleus of "+img_tit);
	close("Bin");
	close("imgDUP");

}

function find_3D_NUCLEOLUS(img_path,img_tit){
	
	run("Duplicate...", "title=tempDUP_NUCLEOLUS duplicate");
	selectWindow("tempDUP_NUCLEOLUS");
	run("Gaussian Blur...", "sigma=GaussianBlur stack");
	run("Subtract Background...", "rolling=SubtractBackground stack");
	run("HiLo");
	run("Subtract...", "value=Subtract stack");
	run("3D Simple Segmentation", "low_threshold=SimpleSegmentationThreshold min_size=SimpleSegmentationMin max_size=SimpleSegmentationMax");
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
