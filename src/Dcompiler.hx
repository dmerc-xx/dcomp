package ;
import lexer.Scanner;
import parser.Parser;
import tree.AST;

/**
 * ...
 * @author skeq
 */

class Dcompiler 
{

	public function new() 
	{
		var fname:String = 'file.d';
		var src:String = Loader.getFile(fname);
		var lex:Scanner = new Scanner(src);
		lex.analyze();
		var lexout:Array<Token> = lex.output();
		//write tokens
		var o:String = '';
		for (t in lexout) {
			o += Std.string(t) + '\n';
		}
		Loader.write(fname + '.tokens', o);
		//parse
		var parser:Parser = new Parser(lexout);
		parser.parse();
		var parseout:AST = parser.output();
		Loader.write(fname + '.ast', parseout.treedump());
		//generate
		var gen:GeneratorHTML = new GeneratorHTML(parseout);
		gen.generate();
		var genout:String = gen.output();
		Loader.write(fname + '.html', genout);
	}
	
}