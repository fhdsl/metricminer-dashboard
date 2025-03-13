
# metricminer dashboard template <img src="https://raw.githubusercontent.com/fhdsl/metricminer/main/resources/metricminer-gnome.png" width = "100">

This repository is a template dashboard website for you to display metrics mined from various places on the web using metricminer.

[See the metricminer website for more info](https://www.metricminer.org/)

## Setting up your dashboard repository

1. To get started, go to the [metricminer-dashboard template GitHub repo](https://github.com/fhdsl/metricminer-dashboard)
2. Click the green "Use this template" button in the upper right corner. If you do not see it, make sure you are logged in to GitHub (and have an account).
3. Name your new metricminer dashboard repository on this screen. Then click "Create new repository".
4. Create your GitHub secret by going to https://github.com/settings/tokens/new
5. Make sure your GitHub secret has the `repo` scopes box checked. Name it something that will remind you it has to do with your metricminer dashboard and then scroll to the bottom and click "Generate Token". Keep this page open for now.
6. Return to your metricminer dashboard repository and go to Settings > Secrets and variables > Actions.
7. Click on `New repository secret`. Name your new secret *exactly* `METRICMINER_GITHUB_PAT`
8. Copy and paste your Personal access token in the `Secret` box and then click the green "Add secret" button.


<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

  - [Setting up your dashboard repository](#setting-up-your-dashboard-repository)
  - [Setting up your config file](#setting-up-your-config-file)
    - [Overall settings](#overall-settings)
    - [Where your data are saved](#where-your-data-are-saved)
    - [Setting up Google Authentication](#setting-up-google-authentication)
    - [Setting up Calendly](#setting-up-calendly)
    - [Setting up CRAN](#setting-up-cran)
    - [Setting up GitHub](#setting-up-github)
    - [Setting up Google Analytics](#setting-up-google-analytics)
    - [Setting up Google Forms](#setting-up-google-forms)
    - [Setting up Slido](#setting-up-slido)
    - [Setting up YouTube](#setting-up-youtube)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Setting up your config file

Return to the `Code` on your metricminer dashboard github repository. And find the `_config_automation.yml` github file. Open up that file and we will start setting up which metrics you'd like to be retrieved.

### Overall settings

metricminer dashboard is an OTTR website with additional metric collecting functionality powered by metricminer.
[You can read more details about how to update your metricminer/OTTR website here](https://www.ottrproject.org/editing_website.html). If you are not familiar with pull requests, we recommend you go read those OTTR docs first.

At the top of the config file you will see a listing of the checks that are run upon filing a pull request. If at any time you don't want these checks to be run you can set them to `no` and GitHub Actions will not run them.
```
# Check that urls in the content are not broken
url-checker: yes
# Render preview of content with changes (Rmd's and md's are checked)
render-preview: yes
# Spell check Rmds and quizzes
spell-check: yes
# Style any R code
style-code: yes
```

### Where your data are saved

By default there are two destinations you can save your data for metricminer (although if you change the code yourself you can feel free to save the data wherever you like).
Built in to metricminer-dashboard however we have github and google as  your options for a data destination.

By default your data is saved to github. But this will only be appropriate for small amounts of data (you could use something called git-lfs but we find it can be a bit of a hassle).
```
### Options are "github" or "google"
data_dest: github
folder_path:
```
If in your config file you choose "google" as your data destination you will need to do two things:
1. Set up your Google Authentication secrets in this repository
2. Give a folder path to your Google drive where you'd like your data to be saved.

### Setting up Google Authentication

Your metricminer dashboard will need permissions to Google if you are saving data there, or wanting to use any data from a Google product including: Google Analytics, Google Forms, Googledrive, or Youtube.

To setup Google Authentication for your metricminer dashboard, you'll need to open up R on your local computer and run the following code:
If you aren't a regular R user you can always use [posit.cloud](https://posit.cloud/) to avoid the installation process.

```
install.packages("metricminer")
token <- authorize("google")
```
Then you can use this object to extract two secrets by printing them out like this and you will need to store both to your metricminer dashboard GitHub secrets (which we will describe how to here).

First, return to your metricminer dashboard repository and go to `Settings` > `Secrets and variables` > `Actions`.
- Click on `New repository secret`. Name your new secret *exactly* `METRICMINER_GOOGLE_ACCESS`
- Copy what is printed out in R when you run:
```
token$credentials$access_token
```
and paste it into the `Secret` box and then click the green "Add secret" button.

Repeat the same steps for the Refresh token except call this `METRICMINER_GOOGLE_REFRESH`
```
token$credentials$refresh_token
```

### Setting up Calendly

1. To set up calendly authorization [go here](https://calendly.com/integrations/api_webhooks) and click "Generate Token".
2. Underneath "Choose a name for this token" pick a name that will remind you of this project.
3. Click "Create Token" and it will send you an authorization code to your email.
4. Click "Copy Token" and keep this handy.
5. Return to your metricminer dashboard repository and go to `Settings` > `Secrets and variables` > `Actions`.
6. Click on `New repository secret`. Name your new secret *exactly* `METRICMINER_CALENDLY`
7. Paste your token into the `Secret` box and then click the green "Add secret" button.

After you've set up authorization you'll need to check the following items in the `_config_automation.yml` file.

- [ ] In the `_config_automation.yml` file, make sure that `refresh-calendly` is set to "yes".
- [ ] Optionally, if you are saving data to google, specify a googlesheet ID you'd like the CRAN data to be saved to. This will only be relevant if you've set `data_dest` to `google`.
```
###### Calendly ######
refresh-calendly: yes
calendly_googlesheet:
```

### Setting up Citations

1. Go to: https://scholar.google.com/scholar
2. Search for the paper you are looking for the citation count.
3. Then click the `Cited by ___` button below the title of the paper
4. Copy and paste this in the `_config_automation.yml` file in the `citation_papers` section.

```
###### Citations ######
refresh-citations: yes
citation_papers: [
  "https://scholar.google.com/scholar?cites=6140457238337460780",
  "https://scholar.google.com/scholar?cites=15945159957067506879" ]
citation_googlesheet:
```
- [ ] In the `_config_automation.yml` file, make sure that `refresh-citations` is set to "yes".
- [ ] Optionally, if you are saving data to google, specify a googlesheet ID in `citation_googlesheet` if you'd like the citation data to be saved to. This will only be relevant if you've set `data_dest` to `google`.

### Setting up CRAN

CRAN does not require any authorization. But in the `_config_automation.yml` you will need to specify a few things.

```
###### CRAN ######
refresh-cran: yes
cran_packages: [ metricminer, ottrpal ]
cran_googlesheet:
```

- [ ] In the `_config_automation.yml` file, make sure that `refresh-cran` is set to "yes".
- [ ] In the `cran_packages` of your `_config_automation.yml`, type the names of the packages that you'd like to collect data from on CRAN. Type them exactly as they are spelled, case sensitive, separated by commas. Delete the example package names we've put there.
- [ ] Optionally, if you are saving data to google, specify a googlesheet ID in `cran_googlesheet` you'd like the CRAN data to be saved to. This will only be relevant if you've set `data_dest` to `google`.


### Setting up GitHub

At this point you should already have your GitHub authorization set up for your metricminer dashboard by having [followed the instructions above.](#setting-up-your-dashboard-repository).

In the `_config_automation.yml` you will need to specify items in the GitHub section.
```
###### GitHub ######
refresh-github: yes
github_repos: [ fhdsl/metricminer, fhdsl/metricminer.org ]
github_googlesheet:
```

- [ ] In the `_config_automation.yml` file, make sure that `refresh-github` is set to "yes".
- [ ] In `github_repos` of your `_config_automation.yml`, specify the names of the repositories you'd like to collect data from in `github_repos`. Make sure it includes the `owner/repository` e.g. `fhdsl/metricminer` not just `metricminer`. Commas need to separate the repositories. Delete the example repositories we put there.
- [ ] Optionally, if you are saving data to Google, specify a googlesheet ID in `github_googlesheet` you'd like the GitHub data to be saved to. This will only be relevant if you've set `data_dest` to `google`.


### Setting up Google Analytics

[Follow the steps from the above section to authenticate Google](#setting-up-google-authentication) -- make sure that the account you have authenticated for has access to the Google Analytics properties you wish to collect.

We'll need to collect the Google Analytics property IDs for the websites you want to retrieve data from.

1. Go to https://analytics.google.com/ -- You may have to login. These instructions are assuming you have already set up Google Analytics and have been collecting data.
2. Then click on the website at the top of the navbar. It will bring you to a dropdown that shows all your websites.

<img src = "resources/images/google-analytics-dropdown.png" width = "50%">

4 .Click on one of the websites where you'd like to retrieve data from. The URL will look something like this:
```
https://analytics.google.com/analytics/web/?authuser=1#/p<PROPERTY_ID_HERE>/reports/home
```
5. Copy the property id and put it in the `ga_property_ids:` part of the `_config_automation.yml`.

Repeat these same steps for all the properties you'd like to collect data for, separating the IDs by commas. Delete the example IDs we have put there as placeholders.

```
###### Google Analytics ######
refresh-ga: yes
ga_property_ids: [ 422671031, 422558989 ]
ga_googlesheet:
```

- [ ] In the `_config_automation.yml` file, make sure that `refresh-ga` is set to "yes".
- [ ] Optionally, if you are saving data to Google, specify a googlesheet ID in `ga_googlesheet` you'd like the GitHub data to be saved to. This will only be relevant if you've set `data_dest` to `google`.

### Setting up Google Forms

[Follow the steps from the above section to authenticate Google](#setting-up-google-authentication) -- make sure that the account you have authenticated for has access to the Google Forms you wish to collect.

Go to a form you'd like to collect data from. The URL should look something like this:
```
https://docs.google.com/forms/u/1/d/<GOOGLE_FORM_ID_HERE>/edit?usp=drive_web
```
Extract the Google Form ID from the URL and put it in the `google_forms` section of the `_config_automation.yml` file.
Do this for each form you'd like to collect data from and separate the form IDs with commas. Delete the example IDs we have put there as placeholders.

```
###### Google Forms ######
refresh-googleforms: yes
google_forms: [
  1pbFfgUPYH2w9zEoCDjCa4HFOxzEhGOseufw28Xxmd-o,
  1JjmsiuVoGSxvl-1M_oWittcftO955tijzeNc-cgJlo8 ]
googleforms_googlesheet:
```

- [ ] In the `_config_automation.yml` file, make sure that `refresh-googleforms` is set to "yes".
- [ ] Optionally, if you are saving data to Google, specify a googlesheet ID in `googleforms_googlesheet` you'd like the GitHub data to be saved to. This will only be relevant if you've set `data_dest` to `google`.

### Setting up Slido

This is assuming you have already exported Slido data to a google drive folder. See [Slido instructions here](https://community.slido.com/analytics-and-exports-44/export-your-questions-poll-results-quiz-leaderboard-and-ideas-532) for how to do that. Navigate to the Google Drive folder that has the Slidos you'd like to collect. Get the URL for this folder. It should look like this:

```
https://drive.google.com/drive/u/1/folders/<SOME_FOLDER_ID_HERE>
```

Put the folder id from this URL in your `drive_id:` category in the `_config_automation.yml` file.
```
###### Slido ######
refresh-slido: yes
drive_id: 1XWXHHyj32Uw_UyaUJrqp6S--hHnM0-7l
slido_googlesheet:
```

- [ ] In the `_config_automation.yml` file, make sure that `refresh-slido` is set to "yes".
- [ ] Optionally, if you are saving data to Google, specify a googlesheet ID in `slido_googlesheet` that you'd like the GitHub data to be saved to. This will only be relevant if you've set `data_dest` to `google`.

### Setting up YouTube

[Follow the steps from the above section to authenticate Google](#setting-up-google-authentication) -- make sure that the account you have authenticated for has access to the YouTube you wish to collect.

Go to a video you'd like to collect data from. The URL should look something like this:
```
https://www.youtube.com/watch?v=<YOUTUBE_VIDEO_ID_HERE>
```
Extract the Youtube Video ID from the URL and put it in the `video_ids` section of the `_config_automation.yml` file. Delete the example IDs we have put there as placeholders.
Do this for each video you'd like to collect data from and separate the IDs with commas.

```
###### YouTube ######
refresh-youtube: yes
video_ids: [ XN_QPRrJZAw, YkYnni-WuaQ ]
youtube_googlesheet:
```

- [ ] In the `_config_automation.yml` file, make sure that `refresh-slido` is set to "yes".
- [ ] Optionally, if you are saving data to Google, specify a googlesheet ID in `youtube_googlesheet` that you'd like the GitHub data to be saved to. This will only be relevant if you've set `data_dest` to `google`.
