/***************************************************

  Company: Ignition Design
   Author: Jeoff Bongar
  Project: Centricminds

     File: PrimaryGenre.java

  Purpose: Provides abstract interface to all
           child object & forces runtime
           polymorphysm.

 ***************************************************/

package ausstage;

public abstract class AusstageInputOutput {

	// common object section
	ausstage.Database m_db;
	admin.AppConstants AppConstants = new admin.AppConstants();

	// object state section
	int m_id = 0;
	int m_preferred_id = 0;
	String m_name = "";
	String m_description = "";
	String m_new_pref_name = "";

	// object state setting section
	public abstract void load(int id);

	public abstract void initialise();

	public abstract void setId(int p_id);

	public abstract void setName(String p_name);

	public abstract void setDescription(String p_description);

	public abstract void setPrefId(int p_id);

	public abstract void setNewPrefName(String p_name);

	// object input output section
	public abstract boolean add();

	public abstract boolean update();

	public abstract boolean delete();

	public abstract int getId();

	public abstract String getName();

	public abstract String getDescription();

	public abstract int getPrefId();

	// object common procedure section
	public abstract boolean isInUse();
}