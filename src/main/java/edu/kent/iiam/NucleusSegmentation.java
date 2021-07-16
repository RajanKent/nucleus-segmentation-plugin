/*
 * To the extent possible under law, the ImageJ developers have waived
 * all copyright and related or neighboring rights to this tutorial code.
 *
 * See the CC0 1.0 Universal license for details:
 *     http://creativecommons.org/publicdomain/zero/1.0/
 */

package edu.kent.iiam;

import net.imagej.ImageJ;
import net.imglib2.type.numeric.RealType;
import org.scijava.command.Command;
import org.scijava.log.LogService;
import org.scijava.plugin.Parameter;
import org.scijava.plugin.Plugin;
import org.scijava.script.ScriptService;
import ij.IJ;
import java.io.File;
import java.io.FileNotFoundException;
import javax.script.ScriptException;

@Plugin(type = Command.class, menuPath = "Plugins>NucleusSegmentation")
public class NucleusSegmentation<T extends RealType<T>> implements Command {


	@Parameter
	private LogService logService;

	// @Parameter
	// private File macro_file;

	@Parameter
	private ScriptService scriptService;

	@Override
	public void run() {
		logService.info("Processing NucleusSegmentation...");

		
		System.out.println("Start NucleusSegmentation... ");

		java.net.URL resource = getClass().getClassLoader().getResource("Macro_12.ijm");

		if (resource == null) {
			IJ.error("file not found!");
			// logService.info("file not found!");
			throw new IllegalArgumentException("file not found!");
		} else {
			IJ.log(resource.getFile());
			// IJ.showMessage(resource.getFile());
			// failed if files have whitespaces or special characters
			File macro_file =  new File(resource.getFile());
			// logService.info(resource.getFile());

			// return new File(resource.toURI());
			System.out.println(macro_file);
			try {
				IJ.showMessage(macro_file.getName());
				scriptService.run(macro_file , true);
			} catch (FileNotFoundException | ScriptException e) {
				IJ.error("Error while scriptService ");
				IJ.error(e.getMessage());
				// TODO Auto-generated catch block
				e.printStackTrace();
				IJ.log(e.getStackTrace().toString());
			}
		}
	

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
