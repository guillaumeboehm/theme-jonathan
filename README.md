<img src="https://cdn.rawgit.com/oh-my-fish/oh-my-fish/e4f1c2e0219a17e2c748b824004c8d0b38055c16/docs/logo.svg" align="left" width="144px" height="144px"/>

#### jonathan
> A theme for [Oh My Fish][omf-link] based on the great [jonathan][omz-johnathan-link] theme from [Oh My Zsh][omz-link] with some elements of the [lambda][omf-lambda-link] theme from [Oh My Fish][omf-link].


[![MIT License](https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square)](/LICENSE)
[![Fish Shell Version](https://img.shields.io/badge/fish-v3.0.0-007EC7.svg?style=flat-square)](https://fishshell.com)
[![Oh My Fish Framework](https://img.shields.io/badge/Oh%20My%20Fish-Framework-007EC7.svg?style=flat-square)](https://www.github.com/oh-my-fish/oh-my-fish)

<br/>


## Install

```fish
$ omf install jonathan
```

## Features

* Made with lots of love
* Jonathan the cat greeting you with some grilled fish (off by default)
* Double prompt line because it's obviously better
* Separation line taking all the width of the terminal
* Wd prompt behavior customisation
* Virtual environment prompt
* Multiplexer prompt
* Last command execution duration prompt
* Very customisable, choose what to display and the color of everything
* Choose your prompt character, I recommend 'ω'

## Configuration

You can override some of the following default options in your `config.fish`:

```fish
###  Main prompt
set -g __jonathan_prompt_char '><>'
set -g __jonathan_prompt_char_rewrite_root no
set -g __jonathan_main_color 80babf
set -g __jonathan_secondary_color 666666
set -g __jonathan_tertiary_color white
set -g __jonathan_use_shrunk_pwd no
set -g __jonathan_pwd_color abc48d
set -g __jonathan_pwd_crop_color 555555
set -g __jonathan_print_time yes
set -g __jonathan_time_color d9bb68
set -g __jonathan_print_git yes
set -g __jonathan_print_env yes
set -g __jonathan_env_color 93879c
set -g __jonathan_print_multiplexer yes
set -g __jonathan_multiplexer_color d17c3d
set -g __jonathan_print_user yes
set -g __jonathan_user_color 80babf
set -g __jonathan_print_hostname yes
set -g __jonathan_hostname_color abc48d
set -g __jonathan_minimum_midbar_length 3
set -g __jonathan_show_pwd_beginning_on_crop 15

set -g __fish_git_prompt_char_stateseparator ' '
set -g __fish_git_prompt_color 80babf
set -g __fish_git_prompt_color_flags df5f00
set -g __fish_git_prompt_color_prefix white
set -g __jonathan_git_prompt_show_informative_status yes
set -g __jonathan_git_prompt_showdirtystate yes
set -g __jonathan_git_prompt_showuntrackedfiles yes
set -g __jonathan_git_prompt_showstashstate yes

### Right prompt
set -g __jonathan_print_cmd_duration yes
set -g __jonathan_cmd_duration_short_color 008888
set -g __jonathan_cmd_duration_long_color cc2200
set -g __jonathan_print_return_code yes
set -g __jonathan_return_code_success_color abc48d
set -g __jonathan_return_code_error_color red
set -g __jonathan_print_date yes
set -g __jonathan_date_format '+%a,%B%d'
set -g __jonathan_date_color d9bb68

### Greeting
set -g __jonathan_print_greeting no
set -g __jonathan_print_greeting_on_multiplexer no
set -g __jonathan_greeting_color FFFFFF
set -g __jonathan_greeting_msg <greeting message>
```
### Git options
- `__fish_git_prompt_char_stateseparator`. Character separating the branch name and the status, default is ` `.
- `__fish_git_prompt_color`. Color of the branch name, default is `80babf`.
- `__fish_git_prompt_color_flags`. Color of the status flags, default is `df5f00`.
- `__fish_git_prompt_color_prefix`. Color of the text prefixing the branch name, default is `white`.
- `__jonathan_git_prompt_show_informative_status`. Shows detailed information for the git status, default is `yes`.
- `__jonathan_git_prompt_showdirtystate`. Shows if the repository is "dirty", i.e. has uncommitted changes.
- `__jonathan_git_prompt_showuntrackedfiles`. Shows if the repository has untracked files (that aren't ignored). Default is `yes`.
- `__jonathan_git_prompt_showstashstate`. Shows the state of the stash, default is `yes`.
- For even more customisation check https://fishshell.com/docs/current/cmds/fish_git_prompt.html
### Color options
- `__jonathan_main_color`. Changes the color of the filler lines, the prompt character and some parentheses, default is `80babf`.
- `__jonathan_secondary_color`. Changes the color of some parentheses and the user/hostname separating character, default is `666666`.
- `__jonathan_pwd_crop_color`. Changes the color of the `...` characters used when cropping the working directory prompt, default is `555555`.
- `__jonathan_cmd_duration_short_color` and `__jonathan_cmd_duration_long_color`. Changes the colors for the previous command execution duration prompt, defaults are `008888` for a short duration and `cc2200` for a long duration.
- See the `Configuration` section for explicit colors I didn't mention here.
### Prompt options

- `__jonathan_prompt_char`. Changes the last prompt chars before the cursor, default is `'><>'`.
- `__jonathan_prompt_char_rewrite_root`. If set to `yes`, the `__jonathan_prompt_char` character will be used as root prompt character instead of the default `#`.
- `__jonathan_use_shrunk_pwd`. If set to `yes`, will show the working directory as `~/m/s/directory` instead of `~/my/super/directory`.
- `__jonathan_print_*`. `yes` to show `no` to hide (who would have thought). You can replace `*` by `time,git,env,multiplexer,user,hostname,cmd_duration,return_code,date,greeting`. All are `yes` by default except for `greeting`.
- `__jonathan_minimum_midbar_length`. Sets the minimum length of the middle filling bar before starting to crop the working directory. Default is `3`.
- `__jonathan_show_pwd_beginning_on_crop`. Sets the number of characters of the wd to show before starting to crop. Default is `15`, `0` will directly start to crop the wd.
- `__jonathan_date_format`. Sets the format for the date prompt, uses the GNU date command.
- `__jonathan_print_greeting_on_multiplexer`. Set to `yes` to display the greeting message on multiplexer terminals.
- `__jonathan_greeting_msg`. Sets the message displayed on terminal creation, default is jonathan the cat grilling some fish.

## Screenshot

<p align="center">
<img src="https://raw.githubusercontent.com/guillaumeboehm/theme-jonathan/master/screenshot.png">
</p>


# License

[MIT][mit] © [guillaumeboehm][author]


[mit]:                https://opensource.org/licenses/MIT
[author]:             https://github.com/guillaumeboehmtheme-jonathan/graphs/contributors
[omf-link]:           https://www.github.com/oh-my-fish/oh-my-fish
[omz-johnathan-link]: https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/jonathan.zsh-theme
[omz-link]:           https://github.com/ohmyzsh/ohmyzsh
[omf-lambda-link]:    https://github.com/hasanozgan/theme-lambda

[license-badge]:  https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square
