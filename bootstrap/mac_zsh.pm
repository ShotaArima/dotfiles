use strict;
use warnings;
use feature 'say';

use File::Copy qw(copy);
use File::Path qw(make_path);
use Time::Piece;

my $home_dir     = $ENV{HOME} or die "HOME is not set\n";
my $dotfiles_dir = $ENV{DOTFILES} // "$home_dir/dotfiles";
my $config_dir   = "$dotfiles_dir/config";
my $backup_dir   = "$dotfiles_dir/back-up/" . localtime->strftime('%Y%m%d_%H%M%S');

my @files = qw(.zshrc .zprofile);

say "[INFO] DOTFILES_DIR = $dotfiles_dir";
say "[INFO] CONFIG_DIR   = $config_dir";
say "[INFO] BACKUP_DIR   = $backup_dir";

make_path($backup_dir);

for my $f (@files) {
    my $home_file   = "$home_dir/$f";
    my $config_file = "$config_dir/$f";
    my $backup_file = "$backup_dir/$f";

    say "------------------------------";
    say "[TARGET] $home_file";

    if (-l $home_file) {
        say "[SKIP] $home_file is already a symlink";
    } elsif (-e $home_file) {
        copy($home_file, $backup_file)
          or die "Failed to backup $home_file -> $backup_file: $!\n";
        say "[INFO] Backup   : $home_file -> $backup_file";
    } else {
        say "[INFO] $home_file does not exist";
    }

    if (!-e $config_file) {
        say "[SKIP] $config_file does not exist, symlink is not created";
        next;
    }

    unlink $home_file if -e $home_file || -l $home_file;

    symlink $config_file, $home_file
      or die "Failed to create symlink $home_file -> $config_file: $!\n";
    say "[LINK] $home_file -> $config_file";
}

say "------------------------------";
say "[DONE] dotfiles setup finished";