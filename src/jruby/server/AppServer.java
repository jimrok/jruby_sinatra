package jruby.server;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.jruby.CompatVersion;
import org.jruby.embed.LocalContextScope;
import org.jruby.embed.ScriptingContainer;

public class AppServer {
	ScriptingContainer container = null;

	public void start() {


		String file_path = AppServer.class.getProtectionDomain()
				.getCodeSource().getLocation().getFile();

		File f = new File(file_path);
		String ewhine_root = null;
		if (f.isDirectory()) {
			ewhine_root = f.getParent();
		} else {
			ewhine_root = f.getParentFile().getParent();
		}

		System.out.println("Starting AppServer from: " + ewhine_root);
		// System.setProperty("jruby.compile.invokedynamic", "true");
		// System.setProperty("jruby.invokedynamic.all", "true");
		// System.setProperty("jruby.thread.pool.enabled", "true");

		container = new ScriptingContainer(LocalContextScope.CONCURRENT);

		container.setClassLoader(AppServer.class.getClassLoader());
		container.setCompatVersion(CompatVersion.RUBY1_9);
		

		 List<String> loadPaths = new ArrayList<String>();
		
		 loadPaths.add(ewhine_root);
		// loadPaths.add(jruby_home + "/ruby/1.9");
		// JRuby 1.5.x
		 container.setLoadPaths(loadPaths);
		
		
		
		String rake_env = System.getProperty("rack.env", "development");

		String script = "RUN_EMBEDDED = true\n" + "ENV['RACK_ENV']='"
				+ rake_env + "'\n" + "begin\n" + "require '" + ewhine_root
				+ "/boot'\n" + "rescue Exception => e\n"
				+ "puts e.backtrace.join(\"\\n\")\n" + "end\n";

		container.runScriptlet(script);

	}

	public void stop() {
		container.terminate();
		
	}

	public static void main(String[] args) throws InterruptedException {
		AppServer jruby_manager = new AppServer();
		jruby_manager.start();
	}

}
