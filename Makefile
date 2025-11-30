# Makefile to load all SSH keys in ~/.ssh

SSH_DIR = $(HOME)/.ssh

.PHONY: loadkeys check testagent

# Load all private SSH keys in ~/.ssh
loadkeys:
	@echo "Starting SSH agent..."
	@ssh-agent bash -c '\
		echo "Adding all SSH private keys in $(SSH_DIR)..."; \
		for key in $(SSH_DIR)/*; do \
			case $$key in \
				*.pub) continue ;; \
				*known_hosts*) continue ;; \
				*) \
					if [ -f $$key ]; then \
						ssh-add $$key >/dev/null 2>&1 && echo "Loaded: $$key"; \
					fi; \
					;; \
			esac; \
		done; \
		echo "Testing GitHub connection..."; \
		ssh -T git@github.com || true; \
	'

# Show loaded identities
check:
	@echo "Currently loaded SSH keys:"
	@ssh-add -l || echo "No SSH agent running"

# Start agent only
testagent:
	@ssh-agent bash -c 'ssh-add -l || echo "No keys loaded"'

