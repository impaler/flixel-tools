package;

import massive.sys.cmd.CommandLineRunner;
import massive.haxe.util.TemplateUtil;

import commands.TemplateCommand;
import commands.CreateCommand;
import commands.SetupCommand;
import commands.DownloadCommand;
import commands.ConvertCommand;
import commands.ValidateCommand;

class FlxTools extends CommandLineRunner
{

	inline static public var NAME = "HaxeFlixel";
	inline static public var ALIAS = "flixel";
	inline static public var VERSION = "0.0.2";

	inline static public var FLIXEL_TEMPLATE_REPO = "https://github.com/HaxeFlixel/flixel-templates.git";
	inline static public var FLIXEL_DEMOS_REPO = "https://github.com/HaxeFlixel/flixel-demos.git";

	static public var flixelVersion:String;

	public function new():Void
	{
		super();

		mapCommand(
			CreateCommand,
			"create", ["c"],
			"Creates a copy of a Demo project.",
			TemplateUtil.getTemplate("create")
		);

		mapCommand(
			SetupCommand,
			"setup", ["st"],
			"Setup the tools, download the Demos and Templates haxelib.",
			TemplateUtil.getTemplate("setup")
		);

		mapCommand(
			DownloadCommand,
			"download", ["dw"],
			"Download the Templates and Demos.",
			""
			// TemplateUtil.getTemplate("download")
		);

		mapCommand(
			TemplateCommand,
			"template", ["t"],
			"Creates a project template.",
			""
			//TemplateUtil.getTemplate("template")
		);

		mapCommand(
			ConvertCommand,
			"convert", ["cn"],
			"Converts an old HaxeFlixel Project.",
			""
			// TemplateUtil.getTemplate("convert")
		);

		mapCommand(
			ValidateCommand,
			"validate", ["v"],
			"Compiles a project to validate for compile errors.",
			""
			// TemplateUtil.getTemplate("validate")
		);

		run();
	}

	// override public function run():Void
	// {
	// 	super.run();

	// 	displayInfo();
	// }

	override public function printHeader():Void
	{
		displayInfo();

		// Sys.println("");
		// Sys.println("" + NAME + " Command-Line Tools (" + VERSION + ")");
		// Sys.println("");
	}

	/**
	 * Display the main information about HaxeFlixel
	 */
	static private function displayInfo():Void
	{
		// Get the current flixel version
		// if (flixelVersion == null)
		// {
		// 	var flixelHaxelib:HaxelibJSON = CommandLine.getHaxelibJsonData("flixel");
		// 	flixelVersion = flixelHaxelib.version;
		// }

		Sys.println("");
		Sys.println(" _   _               ______ _  _          _");
		Sys.println("| | | |              |  ___| ||_|        | |");
		Sys.println("| |_| | __ ___  _____| |_  | |____  _____| |");
		Sys.println("|  _  |/ _` \\ \\/ / _ \\  _| | || \\ \\/ / _ \\ |");
		Sys.println("| | | | (_| |>  <  __/ |   | || |>  <  __/ |");
		Sys.println("|_| |_|\\__,_/_/\\_\\___\\_|   |_||_/_/\\_\\___|_|");
		Sys.println("");
		Sys.println("Powered by the Haxe Toolkit and OpenFL");
		Sys.println("Please visit www.haxeflixel.com for community support and resources!");
		Sys.println("");
		Sys.println("" + NAME + " Command-Line Tools (" + VERSION + ")");
		Sys.println("");

		// if (flixelVersion == "0.0.1")
		// {
		// 	Sys.println("                     flixel is currently not installed!");
		// }
		// else
		// {
		// 	Sys.println("                   Installed flixel version: " + flixelVersion);
		// }
	}


	//Required by the Compiler
	static public function main():FlxTools { return new FlxTools(); }

}