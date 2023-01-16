# Sven Co-op Admin Syncronization

Sven Co-op Admin Syncronization is an AMXX plugin that allows server operators to syncronize their AMXX admins with [Sven Co-op's own administrator system](http://www.svencoop.com/manual/server-advanced.html#admins).

### Cvars

* **amx_svenadmin_enabled**
  * Enables the plugin. 
    * Takes effect on map start. 
    * Note that *it will wipe out your admins file*.
    * Default `"1"`
* **amx_svenadmin_ownerflags**
  * Specifies which flags admins need to have to be considered a server owner. 
    * Default `"abcdefghijklmnopqrstuv"`
* **amx_svenadmin_adminflags**
  * Specifies which flags admins need to have to be considered a server administrator. 
    * Default `"bcdefghijklmnopqrstuv"`