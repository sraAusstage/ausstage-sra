package admin;

public class IniFileNode {

	public IniFileNode() {
		numitems = 0;
		maxitems = 50;
		title = new String("");
		names = new String[maxitems];
		values = new String[maxitems];
	}

	public int numItems() {
		return numitems;
	}

	public boolean addItem(String name, String value) {
		if (name.length() == 0) return false;
		if (numitems >= maxitems) {
			String temp1[] = new String[maxitems + 50];
			String temp2[] = new String[maxitems + 50];
			for (int i = 0; i < maxitems; i++) {
				temp1[i] = names[i];
				temp2[i] = values[i];
			}

			for (int i = maxitems; i < maxitems + 50; i++) {
				temp1[i] = new String();
				temp2[i] = new String();
			}

			names = temp1;
			values = temp2;
		}
		for (int i = 0; i < numitems; i++)
			if (names[i].compareTo(name) == 0) return changeItem(name, value);

		names[numitems] = name;
		values[numitems] = value;
		numitems++;
		return true;
	}

	public String getItem(String name) {
		int i;
		for (i = 0; i < numitems && names[i].compareTo(name) != 0; i++)
			;
		if (i == numitems)
			return new String();
		else
			return values[i];
	}

	public String getItem(int pos) {
		if (pos < 0 || pos >= numitems)
			return new String();
		else
			return values[pos];
	}

	public boolean changeItem(String name, String value) {
		int i;
		for (i = 0; i < numitems && names[i].compareTo(name) != 0; i++)
			;
		if (i == numitems) {
			return false;
		} else {
			values[i] = value;
			return true;
		}
	}

	public boolean changeItem(int pos, String value) {
		if (pos < 0 || pos >= numitems) {
			return false;
		} else {
			values[pos] = value;
			return true;
		}
	}

	public String getItemName(int pos) {
		if (pos < 0 || pos >= numitems)
			return new String();
		else
			return names[pos];
	}

	public boolean removeItem(String name) {
		int i;
		for (i = 0; i < numitems && names[i].compareTo(name) != 0; i++)
			;
		if (i == numitems) return false;
		if (i < numitems - 1) {
			numitems--;
			values[i] = values[numitems];
			names[i] = names[numitems];
			values[numitems] = "";
			names[numitems] = "";
		} else {
			numitems--;
			values[numitems] = "";
			names[numitems] = "";
		}
		return true;
	}

	public boolean removeItem(int pos) {
		if (pos < 0 || pos >= numitems) return false;
		if (pos < numitems - 1) {
			numitems--;
			values[pos] = values[numitems];
			names[pos] = names[numitems];
			values[numitems] = "";
			names[numitems] = "";
		} else {
			numitems--;
			values[numitems] = "";
			names[numitems] = "";
		}
		return true;
	}

	void erase() {
		for (int i = 0; i < numitems; i++) {
			names[i] = "";
			values[i] = "";
		}

		title = "";
		numitems = 0;
	}

	protected int numitems;
	protected int maxitems;
	public String title;
	protected String names[];
	protected String values[];
}
