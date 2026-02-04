//===============================================================================
// Enhances the signal of the max GFP images to create the raw masks 
// - Laura Breimann - 
//===============================================================================

// Ask for the input and output folders
#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix



processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}


function processFile(input, output, file) {
	//open file
	open(input + File.separator + file);
	print("Processing: " + input + File.separator + file);
	selectWindow(file);
	// add gaussian blur to  image
	// the sigma value needs to be determined before
	run("Gaussian Blur...", "sigma=1 stack");
	run("Enhance Contrast...", "saturated=0.35");
	//optional smoothing command if camera noise is visible in the images
	run("Smooth");
	// save new image to folder and close the windows
	print("Saving to: " + output);
	saveAs("Tiff", output + File.separator +  file);
	selectWindow(file);
	close(file);


	
}
print("Done");