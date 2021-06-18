FROM ubuntu:14.04

RUN apt-get update && \
    apt-get install -y git cmake make gcc g++ autoconf zsh

RUN git clone https://github.com/HadesD/dotfiles.git ~/dotfiles && \
    cd ~/dotfiles && \
    ./install.sh

CMD tail -f /dev/null

