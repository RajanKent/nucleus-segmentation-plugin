/*
 * To the extent possible under law, the ImageJ developers have waived
 * all copyright and related or neighboring rights to this tutorial code.
 *
 * See the CC0 1.0 Universal license for details:
 *     http://creativecommons.org/publicdomain/zero/1.0/
 */

package edu.kent.iiam;

import net.imagej.Dataset;
import net.imagej.ImageJ;
import net.imagej.ops.OpService;
import net.imglib2.RandomAccessibleInterval;
import net.imglib2.img.Img;
import net.imglib2.type.numeric.RealType;
import org.scijava.command.Command;
import org.scijava.log.LogService;
import org.scijava.plugin.Parameter;
import org.scijava.plugin.Plugin;
import org.scijava.script.ScriptService;
import org.scijava.ui.UIService;

import net.imagej.ImageJ;
import net.imglib2.algorithm.labeling.ConnectedComponents;
import net.imglib2.img.Img;
import net.imglib2.roi.labeling.ImgLabeling;
import net.imglib2.roi.labeling.LabelRegions;
import net.imglib2.type.numeric.IntegerType;

import ij.IJ;
import ij.ImagePlus;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.print.DocFlavor.URL;
import javax.script.ScriptException;

@Plugin(type = Command.class, menuPath = "Plugins>NucleusSegmentation")
public class NucleusSegmentation<T extends RealType<T>> implements Command {

	// @Parameter(label = "Sigma:", description = "Sigma value for GaussFilter.")
	// private static double sigma = 1.2;
	@Parameter
	private LogService logService;

	// @Parameter
	// private File macro_file;

	@Parameter
	private ScriptService scriptService;

	@Override
	public void run() {
		ImageJ ij = new ImageJ();

		System.out.println("Start NucleusSegmentation... ");

		java.net.URL resource = getClass().getClassLoader().getResource("Macro_12.ijm");

		if (resource == null) {
			throw new IllegalArgumentException("file not found!");
		} else {

			// failed if files have whitespaces or special characters
			File macro_file =  new File(resource.getFile());
			// return new File(resource.toURI());
			System.out.println(macro_file);
			try {
				scriptService.run(macro_file , true);
			} catch (FileNotFoundException | ScriptException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		//		File macro_file;
		//		try {
		//			macro_file = (File) ij.io().open(Object.class.getResource("./Macro_12.ijm").getPath());
		//			System.out.println("Counted " + macro_file);
		//
		////				scriptService.run(macro_file , true);
		//		} catch (IOException e) {
		//			// TODO Auto-generated catch block
		//			e.printStackTrace();
		//			logService.error(e.toString());
		//			System.out.println("Start NucleusSegmentation... "+ e);
		//			System.out.println("Start NucleusSegmentation... "+ e.toString());
		//
		//		};

	}

	/**
	 * This main function serves for development purposes. It allows you to run the
	 * plugin immediately out of your integrated development environment (IDE).
	 *
	 * @param args whatever, it's ignored
	 * @throws Exception
	 */
	public static void main(final String... args) throws Exception {
		// create the ImageJ application context with all available services
		final ImageJ ij = new ImageJ();
		ij.command().run(NucleusSegmentation.class, true);
		System.out.println("Processing NucleusSegmentation...");
	}

}
