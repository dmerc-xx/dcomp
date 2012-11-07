package ;

/**
 * ...
 * @author skeq
 */

enum TokenType {
	ELEMENT;
	ATTRIBUTEID;
	ATTRIBUTECLASS;
	ATTRIBUTE;
	ATTRIBUTEVALUE;
	SOURCE;
	INCLUDE;
	VARDEF;
	VARVALUE;
	VAR;
	COMMENT;
	NCOMMENT;
	MCOMMENT;
	INDENT;
	DEDENT;
	COMMENTTAG;
	//dont go to parser. maybe refactor lexer so i wouldnt need them here.
	NONE;
	ERROR;
}
typedef Token = {
	var type:TokenType;
	var line:Int;
	var pos:Int;
	var cargo:String;
}