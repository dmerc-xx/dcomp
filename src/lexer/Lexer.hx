package lexer;
import lexer.BroadPhase;
import Token;
/**
 * ...
 * @author skeq
 */

class Lexer 
{
	var TokenTypes:Dynamic<Array<Array<Dynamic>>>;
	var stack:Array<String>;
	var state:Array<Array<Dynamic>>;
	var out:Array<Token>;
	var lineN:Int;
	static inline var debugTrace:Bool = false;
	public function parse(lines:Array<Line>):Array<Token> {
		out = new Array<Token>();
		stack.push('root');
		updateState();
		
		for (i in 0...lines.length) {
			var line:Line = lines[i];
			var pos:Int = 0;
			scanIndents(line);
			var ret:Bool = true;
			var scanline:String = line.data;
			while (ret) {
				if(debugTrace){ trace('--------scan line: '+scanline); }
				var matchPos = scan(scanline, i, pos);
				if (matchPos == null) {
					ret = false;
				}else {
					pos += matchPos.pos + matchPos.len;
					scanline = scanline.substr(matchPos.pos+matchPos.len);
				}
			}
		}
		return out;
	}
	function scan(s:String,line:Int,pos:Int) {
		for ( i in 0...state.length) {
			var rule = state[i];
			var reg:EReg = rule[0];
			if (reg.match(s)) {
				if ( rule[1] == TokenType.ERROR ) {
					throw rule[2] + ' | line:'+line+' | col:'+reg.matchedPos().pos;
				} else if ( rule[1] == TokenType.NONE ) {
					
				} else {
					//add token only if its not error or none
					if (debugTrace) { trace(Std.format("token ${rule[1]} matched to ${reg.matched(0)}")); }
					var linePos:Int = pos + reg.matchedPos().pos;
					var token:Token = { line:line, pos:linePos, type:rule[1], cargo:reg.matched(0) };
					out.push(token);
				}
				//action
				var action:String = rule[2];
				switch (action) 
				{
					case "#pop":
						var p:Dynamic = stack.pop();
						if (debugTrace) { trace("#pop |" + p + "| to |" + stack[stack.length - 1] + '|'); }
						updateState();
					case "#pop:2":
						stack.pop();
						var p:Dynamic = stack.pop();
						if(debugTrace){ trace("#pop:2 |" + p + "| to |" + stack[stack.length - 1] + '|'); }
						updateState();
					case null://leave this line be
					default:
						if (Reflect.hasField(TokenTypes, action)) {
							if(debugTrace){ trace('#push |'+action+'|'); }
							stack.push(action);
							updateState();
						}else {
							throw Std.format("undefined state $action");
						}
				}
				return reg.matchedPos();
			}
		}
		return null;
	}
	function scanIndents(line:Line) {
		if (stack[stack.length - 1] == 'root') {
			if (line.indent > 0) {
				var t:Token = { line:line.i,pos:line.indent, type:TokenType.INDENT,cargo:'>' };
				out.push(t);
			}else if(line.indent < 0){
				var t:Token = { line:line.i,pos:line.indent, type:TokenType.DEDENT,cargo:'<' };
				out.push(t);
			}
		}
	}
	function updateState() {
		var stateName:String = stack[stack.length - 1];
		if (!Reflect.hasField(TokenTypes, stateName)) {
			throw Std.format("tried to lex undefined state '$stateName'");
		}else {
			state = Reflect.field(TokenTypes, stateName);
		}
	}
	public function new() {
		stack = new Array<String>();
		TokenTypes = {
			root:[
				[~/^\/\/\/[\r\n\t\s]*/, TokenType.NCOMMENT],
				[~/^\/\/[\r\n\t\s]*/, TokenType.COMMENT],
				[~/^[\r\n\t\s]*\/\*/, TokenType.MCOMMENT, 'mcomment'],
				[~/^var[\r\n\t\s]\$[A-Za-z]+[A-Za-z0-9-_]*[\r\n\t\s]*/, TokenType.VARDEF, 'vardef' ],
				[~/^[A-Za-z]+[A-Za-z]*/, TokenType.ELEMENT, 'element'],
				[~/^\.(.)*$/, TokenType.SOURCE],
				[~/\$[A-Za-z]+[A-Za-z0-9-_]*/,TokenType.VAR]
			],
			mcomment:[
				[~/^[\r\n\t\s]*\/\*/, TokenType.MCOMMENT, 'mcomment'],
				[~/@[A-Za-z]+[A-Za-z0-9-_]*[\r\n\t\s]*/, TokenType.COMMENTTAG],
				[~/\*\//, TokenType.MCOMMENT, '#pop']
			],
			element: [
				[~/#[A-Za-z]+[A-Za-z0-9-_]*[\r\n\t\s]/,TokenType.ATTRIBUTEID,'substr'],
				[~/\.[A-Za-z]+[A-Za-z0-9-_]*[\r\n\t\s]/,TokenType.ATTRIBUTECLASS],
				[~/:[A-Za-z]+[A-Za-z0-9-_]*[\r\n\t\s]*/, TokenType.ATTRIBUTE, 'attribute'],
				[~/$/,TokenType.NONE,'#pop']
			],
			attribute: [
				[~/=[\r\n\t\s]*/, TokenType.NONE, 'attributeValue'],
				[~/$/,TokenType.ERROR,'attributes without value']
			],
			attributeValue: [
				[~/'(.)*'/, TokenType.ATTRIBUTEVALUE,'#pop:2'],
				[~/$/,TokenType.ERROR,'unfinished attribute value']
			],
			vardef:[
				[~/[A-Za-z]+[A-Za-z0-9-_]*[\r\n\t\s]*$/,TokenType.VARVALUE,'#pop'],
				[~/$/,TokenType.ERROR,'no value found after var definition']
			],
			expr:[
			
			],
			die:[
				[~/./,TokenType.ERROR,'DEAD']
			]
		}
	}
}