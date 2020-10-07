## Overview


Verify that HashiCups is running by sending a request to its health check endpoint
`curl localhost:19090/health`{{execute T2}}

<details style="padding-bottom: 1em;">
<summary>Grant access to specific GitHub repositories</summary>
<br/>
If your forked repository does not appear in the list of repositories above,
follow these steps to grant Terraform Cloud access to the repository.<br/>
<br/>
1. Log in to [GitHub](https://github.com).<br/>
2. Navigate to your user profile settings by clicking on your profile picture in
   the upper right, and choosing "Settings" from the menu.<br/>
3. On the settings page, select "Applications" from the menu on the left.<br/>
4. "Terraform Cloud" should be listed here. Click the "Configure" button next to
   it.<br/>
  - If "Terraform Cloud" does not appear, then Terraform Cloud has not been
    configured to access GitHub. Return to Terraform Cloud to connect it to
    GitHub as described above.<br/>
5. On the next page, you can either grant Terraform Cloud access to all of your
   GitHub repositories, or use the "Only select repositories" interface to
   select the repository you forked earlier.<br/>
6. If you only grant access to select repositories, you will need to repeat the
   last step for all three of the repositories used in this workshop.<br/>
</details>

<details style="padding-bottom: 1em;">
<summary>Grant access to specific GitHub repositories</summary>
<br/>
If your forked repository does not appear in the list of repositories above,
follow these steps to grant Terraform Cloud access to the repository.<br/>
<br/>
<ol type="1">
    <li>Log in to [GitHub](https://github.com).</li>
    <li>Navigate to your user profile settings by clicking on your profile picture in
    the upper right, and choosing "Settings" from the menu.</li>
    <li>On the settings page, select "Applications" from the menu on the left.</li>
    <li>
        "Terraform Cloud" should be listed here. Click the "Configure" button next to it.
        <ul>
        <li>If "Terraform Cloud" does not appear, then Terraform Cloud has not been
            configured to access GitHub. Return to Terraform Cloud to connect it to
            GitHub as described above.</li>
        </ul>
    </li>
    <li>On the next page, you can either grant Terraform Cloud access to all of your
    GitHub repositories, or use the "Only select repositories" interface to
    select the repository you forked earlier.</li>
    <li>If you only grant access to select repositories, you will need to repeat the
    last step for all three of the repositories used in this workshop.</li>
</ol>
</details>

<details style="padding-bottom: 1em;">
<summary>Grant access to specific GitHub repositories</summary>
<br/>
If your forked repository does not appear in the list of repositories above,
follow these steps to grant Terraform Cloud access to the repository.<br/>
<br/>
<ol type="1">
    1. Log in to [GitHub](https://github.com).

    1. Navigate to your user profile settings by clicking on your profile picture in the upper right, and choosing "Settings" from the menu.

    1. On the settings page, select "Applications" from the menu on the left.

    1. "Terraform Cloud" should be listed here. Click the "Configure" button next to it.
    
        - If "Terraform Cloud" does not appear, then Terraform Cloud has not been configured to access GitHub. Return to Terraform Cloud to connect it to GitHub as described above.

    1. On the next page, you can either grant Terraform Cloud access to all of your GitHub repositories, or use the "Only select repositories" interface to select the repository you forked earlier.
    
    1. If you only grant access to select repositories, you will need to repeat the last step for all three of the repositories used in this workshop.
</details>