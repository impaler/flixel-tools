package commands;

import utils.CommandUtils;
import sys.io.File;
import massive.sys.io.FileSys;
import massive.sys.cmd.Command;

class SetupCommand extends Command
{

	private var autoContinue:Bool = false;

	override public function execute():Void
	{
		if (console.args.length > 3)
		{
			this.error("You have given too many arguments for the create command.");
		}

		if(console.getOption("-y") != null)
			autoContinue = true;

		var haxePath:String = Sys.getEnv("HAXEPATH");

		if (FileSys.isWindows)
		{
			if (haxePath == null || haxePath == "")
			{
				haxePath = "C:\\HaxeToolkit\\haxe\\";
			}

			File.copy(CommandUtils.getHaxelibPath("flixel-tools") + "\\\\bin\\flixel.bat", haxePath + "\\flixel.bat");
		}
		else
		{
			if (haxePath == null || haxePath == "")
			{
				haxePath = "/usr/lib/haxe";
			}

			Sys.command("sudo", [ "cp", CommandUtils.getHaxelibPath("flixel-tools") + "bin/flixel.sh", haxePath + "/flixel" ]);
			Sys.command("sudo chmod 755 " + haxePath + "/flixel");
			Sys.command("sudo ln -s " + haxePath + "/flixel /usr/bin/flixel");
		}

		Sys.println("You have now setup HaxeFlixel");

		Sys.command("flixel");

		if(!autoContinue)
		{
			var download = CommandUtils.askYN ("Would you now like this tool to download the flixel-demos and
		flixel-templates?");

			if(download == Answer.Yes)
			{
				Sys.command ("flixel download");
			}
			else
			{
				exit();
			}
		}
		else
		{
			Sys.command ("flixel download");
			exit();
		}

	}
}