# Virtuemart SVN Package Generator
Generates a joomla installation package from the virtuemart svn
<br>
<hr>
Since Virtuemart Version 4.0.12 you have to have a payed membership to be able to download an update package.<br>
https://virtuemart.net/news/511-effective-and-sustainable-funding-with-a-virtuemart-membership<br>
<br>
Free-Users only get a complete installation file which cannot be used to update your existing page.<br>
The developer posted a more or less complete tutorial for creating the package on your own.<br>
https://docs.virtuemart.net/tutorials/installation-migration-upgrade/246-how-to-update-virtuemart-from-svn.html.<br>
<br>
Here is a Powershell script which does all the handwork for your.<br>
<hr>
<b>Requirements:</b><br>
<ul>
  <li>SVN has to be installed, incl. the command-line tools (for examlpe: https://tortoisesvn.net/downloads.html)</li>
  <li>7zip has to be installed, incl. the command-line tools (https://www.7-zip.org/download.html)</li>
</ul>
<hr>
<b>Why we need 7zip?</b><br>
Because the compress-archive function from powershell creates archives which cannot be expanded by joomla (some JSON error).<br>
Maybe it's because of the Zip64 Metadata but I didn't look much into it.<br>
<hr>
<b>Procedure to get the package:</b><br>
<ul>
  <li>Install SVN and 7zip</li>
  <li>Download the powershell script</li>
  <li>Execute the script:
    <ul>
      <li>All options can be skipped by pressing enter, then the given default value [] will be used.<br>
      The default values can be changed in the first lines of the script</li>
      <li>Enter a working directory where the svn should be downloaded and where the resulting package will be safed</li>
      <li>Enter a new version-number</li>
      <li>Enter a new release-type (not really needed anywhere beside the version.php file)</li>
      <li>Enter a new code-name (not really needed anywhere beside the version.php file)</li>
      <li>Now the repository will be downloaded
        <ul>
          <li>needed folders will be created and filled</li>
          <li>files will be checked for replacing variables</li>
          <li>folders will be archived</li>
        </ul>
      </li>      
    </ul>
  </li>
  <li>Done! Now you have a complete package like you have it downloaded from the virtuemart page</li>





