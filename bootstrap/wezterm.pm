use strict;
use warnings;
use feature 'say';

use File::Copy qw(move);
use File::Path qw(make_path);
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use Time::Piece;

my $home_dir = $ENV{HOME} or die "HOME is not set\n";

# シンボリックリンクのターゲットは必ず絶対パスにする必要があるため、
# スクリプト自身の場所（bootstrap/）から dotfiles ルートを解決し、abs_path で正規化する。
# 実行時のカレントディレクトリや $DOTFILES の設定に依存しない。
my $script_dir   = dirname(abs_path(__FILE__));
my $dotfiles_dir = abs_path($ENV{DOTFILES} // "$script_dir/..")
  or die "Failed to resolve dotfiles directory\n";
my $src_dir      = abs_path("$dotfiles_dir/.config/wezterm");
my $dest_dir     = "$home_dir/.config/wezterm";
my $backup_dir   = "$dotfiles_dir/back-up/" . localtime->strftime('%Y%m%d_%H%M%S');

if (!$src_dir || !-d $src_dir) {
    die "[ERROR] Source directory does not exist: $dotfiles_dir/.config/wezterm\n";
}

say "[INFO] DOTFILES_DIR = $dotfiles_dir";
say "[INFO] SOURCE       = $src_dir";
say "[INFO] TARGET       = $dest_dir";

# ~/.config は事前に用意（wezterm ディレクトリ自体をリンクするので親のみ作る）
make_path(dirname($dest_dir));

say "------------------------------";

if (-l $dest_dir) {
    my $current = readlink($dest_dir) // '';
    if ($current eq $src_dir) {
        say "[SKIP] $dest_dir already links to $src_dir";
        say "------------------------------";
        say "[DONE] wezterm setup finished";
        exit 0;
    }
    unlink $dest_dir
      or die "Failed to remove old symlink $dest_dir: $!\n";
    say "[INFO] Replaced old symlink: $dest_dir";
} elsif (-e $dest_dir) {
    # 実体（ディレクトリ/ファイル）が存在する場合はバックアップへ退避
    make_path($backup_dir);
    my $backup_path = "$backup_dir/wezterm";
    move($dest_dir, $backup_path)
      or die "Failed to backup $dest_dir -> $backup_path: $!\n";
    say "[INFO] Backup   : $dest_dir -> $backup_path";
} else {
    say "[INFO] $dest_dir does not exist";
}

symlink $src_dir, $dest_dir
  or die "Failed to create symlink $dest_dir -> $src_dir: $!\n";
say "[LINK] $dest_dir -> $src_dir";

say "------------------------------";
say "[DONE] wezterm setup finished";
