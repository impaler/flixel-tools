package utils;

import sys.io.Process;
import sys.io.File;
import massive.sys.io.FileSys;
import haxe.Json;

/**
 * Utilities for command line tools
 */
class CommandUtils
{

	/**
	 * Copy a directory and its contents recursivley
	 * @param  Source      String the source directory to copy
	 * @param  Destination String to destination to copy the directory to
	 * @param  ?Overwrite  Overwrite the destination
	 * @return             Bool true if the new Destination exists after operation
	 */
	static public function copyRecursivley(Source:String, Destination:String, ?Overwrite:Bool):Bool
	{
		var current = massive.sys.io.File.current.resolveDirectory("temp");

		var dir1:massive.sys.io.File = current.resolvePath(Source, true);
		var dir2:massive.sys.io.File = current.resolvePath(Destination, true);
		
		dir1.copyTo(dir2, Overwrite);

		return FileSys.exists(Destination);
	}
	
	/**
	* Basic Ereg match to add an import above the first in a file if none exists
	* @param FilePath     Path to the file to add to
	* @param ImportString The complete import string to seach for and add
	*/
	public static function addImportToFileString(FileString:String, ImportString:String):String 
	{
		var str:String = FileString;
		var match = strmatch(ImportString, str);

		if(!match)
		{
			var newLine = "\n";
			var r = ~/import+/;
			var newString = Reflect.copy(str);
			r.match(str);

			try
			{
				var matchPos = r.matchedPos();
				var beggining = str.substr(0,matchPos.pos);
				var end = str.substr(matchPos.pos, str.length);
				newString = beggining + ImportString + ";" + newLine + end;
			}
			catch (e:Dynamic){}

			if(newString != str)
			{
				return newString;
			}
			else
			{
				return null;
			}

		}

		return null;
	}

    /**
	 * Prompt user with a y/n/a
	 *
	 * @param   Question    String with the prompt to display
	 * @return  User choice in an Answer enum or null if an invalid answer given
	 */
    static public function askYN(Question:String):Answer
    {
        while (true)
        {
            Sys.println(Question + " [y/n] ? ");

            switch (readLine())
            {
                case "n", "No":
                    return No;
                case "y", "Yes":
                    return Yes;
            }
        }

        return null;
    }

	/**
	 * Prompt user with a y/n/a
	 * 
	 * @param   Question    String with the prompt to display
	 * @return  User choice in an Answer enum or null if an invalid answer given
	 */
	static public function askYNA(Question:String):Answer
	{
		while (true)
		{
			Sys.println(Question + " [y/n/a] ? ");    
			
			switch (readLine())
			{
				case "n", "No": 
					return No;
				case "y", "Yes": 
					return Yes;
				case "a", "Always": 
					return Always;
			}
		}
		
		return null;
	}

	/**
	 * As the user a question with automatic numeric references to string answers,
	 * includes simple validation and cancel
	 * @param  Question        String to display as the question
	 * @param  Answers<String> Array<String> containing all the available answers
	 * @return                 String the answer given or null if the choice was invalid
	 */
	static public function askQustionStrings(Question:String, Header:String, Answers:Array<String>):String
	{
		while (true)
		{
			Sys.println("");
			Sys.println(Header);    
			Sys.println("");

			for( i in 0...Answers.length )
			{
				Sys.println( " [" + i + "] " + Answers[i]);
			}

			Sys.println( "");
			Sys.println( " [c] Cancel");
			Sys.println( "");

			Sys.println("");
			Sys.println(Question);    
			Sys.println("");

			var userResponse = readLine();
			var validAnswer = "";

			for( i in 0...Answers.length )
			{
				if( Answers[i] == userResponse || Std.string(i) == userResponse )
				{
					validAnswer = userResponse;
				}
				else if(userResponse == "c")
				{
					Sys.println(" Cancelled");
					return 	null;
				}
			}

			if (validAnswer != "")
			{
				return Answers[Std.parseInt(userResponse)];
			}
			else
			{
				return null;
			}
		}
		
		return null;
	}

	/**
	 * Shortcut to the readline of the command line
	 * 
	 * @return  String of the current line
	 */
	inline static public function readLine()
	{
		return Sys.stdin().readLine();
	}

	/**
	 * Load and parse the date from a Haxelib json file
	 * 
	 * @param   HaxelibName     String name of the Haxelib to load
	 * @return  Haxelib typedef or null if no Haxelib was found
	 */
	static public function getHaxelibJsonData(HaxelibName:String):HaxelibJSON
	{
		var haxleibJsonPath = getHaxelibPath(HaxelibName);
		
		if (haxleibJsonPath == "")
		{
			return null;
		}
		
		var jsonContent:String = File.getContent(haxleibJsonPath + "haxelib.json");
		var jsonData:HaxelibJSON = Json.parse(jsonContent);
		
		return jsonData;
	}


	static public function strmatch(Needle:String, Haystack:String):Bool
	{
		var search = new EReg("\\b" + Needle + "\\b", "");
		return search.match(Haystack);
	}

	/**
	 * Get the path of a Haxelib on the current system
	 * @param  Name String of the Haxelib to scan for
	 * @return      String path of the Haxelib or "" if none found
	 */
	static public function getHaxelibPath(Name:String):String
	{
		var proc:Process = new Process(combine(Sys.getEnv("HAXEPATH"), "haxelib"), ["path", Name]);
		var result:String = "";
		
		try 
		{
			var previous:String = "";
			while (true) 
			{
				var line:String = proc.stdout.readLine();
				if (line == "-D " + Name)
				{
					result = previous;
					break;
				}
				previous = line;
			}
		} 
		catch (e:Dynamic) { };
		proc.close();

		return result;
	}

	/**
	 * Shortcut to join paths that is platform safe
	 */
	static public function combine(FirstPath:String, SecondPath:String):String 
	{
		if (FirstPath == null || FirstPath == "") 
		{
			return SecondPath;
		} 
		else if (SecondPath != null && SecondPath != "") 
		{
			if (FileSys.isWindows) 
			{
				if (SecondPath.indexOf (":") == 1) 
				{
					return SecondPath;
				}
			} 
			else 
			{
				if (SecondPath.substr (0, 1) == "/") 
				{
					return SecondPath;
				}
			}
			
			var firstSlash:Bool = (FirstPath.substr (-1) == "/" || FirstPath.substr (-1) == "\\");
			var secondSlash:Bool = (SecondPath.substr (0, 1) == "/" || SecondPath.substr (0, 1) == "\\");
			
			if (firstSlash && secondSlash) 
			{
				return FirstPath + SecondPath.substr (1);
			} 
			else if (!firstSlash && !secondSlash) 
			{
				return FirstPath + "/" + SecondPath;
				
			} 
			else 
			{
				return FirstPath + SecondPath;
			}
		} 
		else 
		{
			return FirstPath;
		}
	}

	/**
	 * Shortcut to strip a relative path
	 * @param  Path String to strip
	 * @return      Stripped string
	 */
	static public function stripPath(Path:String):String
	{
		if (StringTools.startsWith(Path,"./"))
		{
			Path = Path.substring(2);
		}
		
		if (StringTools.endsWith( Path,"/" ))
		{
			Path = Path.substring(0,Path.length-1);
		}
		return Path;
	}
}

/**
 * Definition of a haxelib json file
 */
typedef HaxelibJSON = {
	name:String,
	url:String,
	license:String,
	tags:Array<String>,
	description:String,
	version:String,
	releasenote:String,
	contributors:Array<String>,
	dependencies:Dynamic
}

/**
 * Type for command user prompts
 */
enum Answer {
	Yes;
	No;
	Always;
}
