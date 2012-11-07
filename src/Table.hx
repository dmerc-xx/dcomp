package ;

/**
 * ...
 * @author skeq
 */

class Table extends Hash<String>
{
	static var _inst:Table;
	public function new()
	{
		super();
	}
	static public function instance():Table {
		if (_inst == null)
			_inst = new Table();
		return _inst;
	}
}