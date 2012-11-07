package parser;
import lexer.TokenList;
import tree.AST;

/**
 * takes a list of tokens and 
 * @author skeq
 */

class Parser 
{
	var tokens:TokenList<Token>;
	var ast:AST;
	var parent:ASTNode;
	var table:Table;
	var rules:Dynamic;
	public function parse() {
		while (tokens.hasNext()) {
			var token:Token = tokens.next();
			trace(token);
			if (Reflect.hasField(rules, Std.string(token.type))) {
				var rule_field:Dynamic = Reflect.field(rules, Std.string(token.type));
				if(Reflect.hasField(rule_field,'action')){
					doAction(token,rule_field.action );
				}
			}else {
				//add to ast as normal element
				parent.addChild(token);
			}
		}
	}
	function doAction(token:Token, rule:String) {
		trace('parser rule: '+rule);
		switch (rule) 
		{
			case 'group':
				if (parent.children.length > 0) {
					//TODO allow only some elements to be parents
					trace('grouping ' + Std.string(token));
					parent = parent.children[parent.children.length - 1];
				}else {
					throw 'invalid indentation. cannot indent here | line:' + token.line;
				}
			case 'degroup':
				if(parent.parent != null){
					parent = parent.parent;
				}else {
					throw 'invalid indentation. cannot dedent above root | line:'+token.line;
				}
			case 'skip':
				//
			case 'define':
				table.set('var', token.cargo);
			default:
				
		}
	}
	public function new(tokens:Array<Token>) 
	{
		this.tokens = TokenList.fromTokenArray(tokens);
		ast = new AST();
		parent = ast;
		table = Table.instance();
		rules = {
			MCOMMENT:{action:'skip'},
			INDENT:{action:'group'},
			DEDENT: { action:'degroup' },
			VARDEF: { action:'ski' },
			VARVALUE: {action:'define'}
		}
	}
/*
rules:
	attributes after element.
	attribute value after attribute
	vardef then varvalue
	mcomment,none,error throw errors(shouldnt come from lexer)
	two indents throw error
	indent,dedent without any description tags in between throws error
	var after attrvalue but not after attr
	
*/
	public function output():AST {
		return ast;
	}
}