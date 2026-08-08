# My dotfiles

## Set up on new machine:

```bash
`sh -c "$(curl -fsLS get.chezmoi.io)" -- init dnlbauer`
```

## One shot (removes chezmoi after install)

```bash
`sh -c "$(curl -fsLS get.chezmoi.io)" -- init --one-shot dnlbauer`
```

## Updateing files

1. Re-add updated files:

`chezmoi re-add .zshrc`

2. git add and commit

```bash
chezmoi cd
git add --all
git commit
git push
```

3. Update machine from remote

`chezmoi update`
