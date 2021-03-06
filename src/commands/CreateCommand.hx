package commands;

import massive.sys.cmd.Command;
import utils.ProjectUtils.OpenFLProject;
import utils.CommandUtils;
import utils.DemoUtils;

class CreateCommand extends Command
{
	override public function execute():Void
	{
		if(console.args.length > 3)
		{
			this.error("You have given too many arguments for the create command.");
		}

		var projects:Array<OpenFLProject> = DemoUtils.scanDemoProjects();

		if(projects == null)
		{
			Sys.println("");
			Sys.println("There were no Demos found.");
			Sys.println("Is your flixel-demos haxelib installed?");
			Sys.println("Try the 'flixel download' command.");
			Sys.println("");
		}

		var demo:OpenFLProject = null;

		if(console.args[1] != null)
		{
			demo = DemoUtils.demoExists(console.args[1]);

			if (demo == null)
			{
				if(Std.parseInt(console.args[1]) != null)
				{
					demo = DemoUtils.getDemoByIndex(Std.parseInt(console.args[1]));

					if(demo == null)
					{
						error("This Demo is not available. Please try run the 'flixel download' command.");
					}
				}
			}
		}
		else
		{
			demo = promptDemoChoice(projects);

			if(demo == null)
			{
				exit();
			}
		}

		Sys.println(" Creating " + demo.NAME);

		var	destination = Sys.getCwd() + demo.NAME;

		var copied = utils.ProjectUtils.duplicateProject(demo,destination);

		if(copied)
		{
			Sys.println("");
			Sys.println(" The Demo " + demo.NAME + " has been created at:");
			Sys.println(destination);
			Sys.println("");
			exit();
		}
		else
		{
			Sys.println("");
			error(" There was an problem creating " + demo.NAME);
		}
	}

	private function promptDemoChoice(projects:Array<OpenFLProject>):OpenFLProject
	{
		for ( project in projects )
		{
			Sys.println(project.NAME);
		}
		var answers = new Array<String>();
		var header = " Listing all the demos you can create.";
		var question = " Please enter a number or name of the demo to create.";

		for (demo in projects)
		{
			answers.push(demo.NAME);
		}

		var answer = CommandUtils.askQustionStrings(question, header, answers);

		if(answer == null)
		{
			Sys.println(" Your choice was not a valid demo.");
			Sys.println("");
			return null;
		}

		var demo = DemoUtils.demoExists(answer);
		if(demo != null)
		{
			return demo;
		}
		return null;
	}

}