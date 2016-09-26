package com.qad.fin.plugin.util;

import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.JarURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;

/**
 * /**
 *
 * @author zal
 */
public class FileUtil {

	public static ArrayList<String> readFileByLines(String fileName) {

		ArrayList<String> codeLines = new ArrayList<String>();
		File file = new File(fileName);
		BufferedReader reader = null;
		try {
			reader = new BufferedReader(new FileReader(file));
			String tempString = null;
			int line = 1;
			while ((tempString = reader.readLine()) != null) {
				codeLines.add(tempString);
				line++;
			}
			reader.close();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (reader != null) {
				try {
					reader.close();
				} catch (IOException e1) {
				}
			}
		}
		return codeLines;
	}
	

	public static synchronized void decompress(String fileName,String outputPath) {
		
		if (!outputPath.endsWith(File.separator)) {
			outputPath += File.separator;
		}
		
		File dir = new File(outputPath);
		if (!dir.exists()) {
			dir.mkdirs();
		}
		JarFile jf = null;
		try {
			jf = new JarFile(fileName);
			for (Enumeration<JarEntry> e = jf.entries(); e.hasMoreElements();) {
				JarEntry je = (JarEntry) e.nextElement();
				String outFileName = outputPath + je.getName();
				File f = new File(outFileName);
				if (je.isDirectory()) {
					if (!f.exists()) {
						f.mkdirs();
					}
				} else {
					File pf = f.getParentFile();
					if (!pf.exists()) {
						pf.mkdirs();
					}
					InputStream in = jf.getInputStream(je);
					OutputStream out = new BufferedOutputStream(new FileOutputStream(f));
					byte[] buffer = new byte[2048];
					int nBytes = 0;
					while ((nBytes = in.read(buffer)) > 0) {
						out.write(buffer, 0, nBytes);
					}
					out.flush();
					out.close();
					in.close();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} 
	}

}
