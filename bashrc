# .bashrc

#########
#General#
#########
export LANG=en_US.UTF-8
export LOCALE=UTF-8
export EDITOR="vim"
EMOJI=$(python ~/dotfiles/scripts/emoji.py)
PS1="[${EMOJI} \u${EMOJI} ] \W $ "
function title {
    echo -ne "\033]0;"$*"\007"
}

function youtube {
    url="$1" ; shift
    eval $(/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --app=$url)
}

#####
#AWS#
#####
ec2l ()
{
    criteria="$1" ; shift
    for inst in `aws ec2 describe-instances --filter instance-state-name=running --filter Name=tag:Name,Values=$criteria --output text --query 'Reservations[*].Instances[*].{Priv:PrivateIpAddress}'` ; do
        echo "found $inst"
        echo "$1"
        command="$1" ; shift
        if [ -z "$command" ]; then
            command="ssh"
        fi
        if [ "$command" == "ssh" ]; then
            command="$command -t -A"
        fi
        $command "$USER"@"$inst" "$*"
    done
    if [ -z "$inst" ] ; then
        echo "could not find a running instance for input \"$criteria\" in. Try again later?"
        return 1
    fi
}

alias aws_resync="aws iam resync-mfa-device --user-name $USER--serial-number $AWS_MFA_DEVICE --authentication-code-1 $1 --authentication-code-2 $2"
function aws_setup {
    awsenv="$1" ; shift
    token="$1" ; shift
    if [ "$awsenv" = "test" ]; then
        export AWS_ACCESS_KEY_ID=
        export AWS_SECRET_ACCESS_KEY=
        export AWS_MFA_DEVICE=
    elif [ "$awsenv" = "dev" ]; then
        export AWS_ACCESS_KEY_ID=
        export AWS_SECRET_ACCESS_KEY=
        export AWS_MFA_DEVICE=
    else
        echo "Invalid Environment"
        return
    fi
    clear
    [-x ~/dotfiles/scripts/get_session_token.py] && eval $(python ~/scripts/get_session_token.py $token)
    if [ ! -z "$AWS_SECRET_KEY" ]; then
        PS1="<${awsenv}>${PS1}"
    fi
}

########
#Python#
########
alias clear_pyc='find . -name "*.pyc" -type f -delete'

export WORKON_HOME=~/.envs
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
[-x /usr/local/bin/virtualenvwrapper.sh] && source /usr/local/bin/virtualenvwrapper.sh


# Automatically activate Git projects' virtual environments based on the
# directory name of the project. Virtual environment name can be overridden
# by placing a .venv file in the project root with a virtualenv name in it
function workon_cwd {
    # Check that this is a Git repo
    GIT_DIR=`git rev-parse --git-dir 2> /dev/null`
    if [ $? == 0 ]; then
        # Find the repo root and check for virtualenv name override
        GIT_DIR=`\cd $GIT_DIR; pwd`
        PROJECT_ROOT=`dirname "$GIT_DIR"`
        ENV_NAME=`basename "$PROJECT_ROOT"`
        if [ -f "$PROJECT_ROOT/.venv" ]; then
            ENV_NAME=`cat "$PROJECT_ROOT/.venv"`
        fi
        # Activate the environment only if it is not already active
        if [ "$VIRTUAL_ENV" != "$WORKON_HOME/$ENV_NAME" ]; then
            if [ -e "$WORKON_HOME/$ENV_NAME/bin/activate" ]; then
                workon "$ENV_NAME" && export CD_VIRTUAL_ENV="$ENV_NAME"
            fi
        fi
    elif [ $CD_VIRTUAL_ENV ]; then
        # We've just left the repo, deactivate the environment
        # Note: this only happens if the virtualenv was activated automatically
        deactivate && unset CD_VIRTUAL_ENV
    fi
}

# New cd function that does the virtualenv magic
function venv_cd {
    cd "$@" && workon_cwd
}

alias cd="venv_cd"


