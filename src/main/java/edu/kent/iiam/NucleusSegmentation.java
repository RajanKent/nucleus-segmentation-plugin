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
import net.imglib2.img.Img;
import net.imglib2.type.numeric.RealType;

import org.scijava.command.Command;
import org.scijava.log.LogService;
import org.scijava.plugin.Parameter;
import org.scijava.plugin.Plugin;
import org.scijava.script.ScriptService;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.concurrent.ExecutionException;
import ij.IJ;

@Plugin(type = Command.class, menuPath = "Plugins>NucleusSegmentation")
public class NucleusSegmentation<T extends RealType<T>> implements Command {

	private String macro_content = null;

	@Parameter
	private Dataset currentData;

	@Parameter
	private LogService logService;

	@Parameter
	private ScriptService scriptService;

	public String ReadBigStringIn(BufferedReader buffIn) throws IOException {
		StringBuilder everything = new StringBuilder();
		String line;
		while ((line = buffIn.readLine()) != null) {
			everything.append(line + "\n");
		}
		return everything.toString();
	}

	@Override
	public void run() {
		System.out.println(currentData);

		// ----------
		
		@SuppressWarnings("unchecked")
		final Img<T> image = (Img<T>) currentData.getImgPlus();

		if (image == null) {
			IJ.noImage();
		} else {

			/////
			logService.info("Processing NucleusSegmentation...");

			System.out.println("Start NucleusSegmentation... ");

			java.net.URL resource = getClass().getClassLoader().getResource("nucleus_seg_macro.ijm");

			if (resource == null) {
				IJ.error("file not found!");
				logService.info("file not found!");
				throw new IllegalArgumentException("file not found!");
			} else {

				try {
					System.out.println("Find macro file... ");

					java.io.InputStream in = getClass().getResourceAsStream("/nucleus_seg_macro.ijm");

					BufferedReader reader = new BufferedReader(new InputStreamReader(in));

					try {

						System.out.println("I'm saving macro file content... ");

						macro_content = ReadBigStringIn(reader);

						// System.out.println(">>>> " + macro_content);

						// in.close();
						reader.close();

					} catch (IOException e1) {
						e1.printStackTrace();
						System.out.println("I'm error when reading macro file");

					}

					scriptService.run(".ijm", macro_content, true, image).get();

				} catch (InterruptedException | ExecutionException e) {
					System.out.println(e.getStackTrace().toString());

					IJ.log("Error while scriptService ");
					IJ.log(e.getMessage());
					e.printStackTrace();
					IJ.log(e.getStackTrace().toString());
				}
			}
			/////

		}
		// -------------

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
