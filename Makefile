VERSION=0.3.3
BUILD=1

prefix=/usr
bindir=${prefix}/bin
libdir=${prefix}/lib
sysconfdir=/etc
mandir=${prefix}/share/man

all:

clean:
	rm -rf man/man*/*.html
	find . -name '*~' -delete

install: install-bin install-lib install-man install-sysconf

install-bin:
	install -d $(DESTDIR)$(bindir)
	find bin -type f -printf %P\\0 | xargs -0r -I__ install bin/__ $(DESTDIR)$(bindir)/__

install-lib:
	find lib -type d -printf %P\\0 | xargs -0r -I__ install -d $(DESTDIR)$(libdir)/__
	find lib -type f -printf %P\\0 | xargs -0r -I__ install -m644 lib/__ $(DESTDIR)$(libdir)/__

install-man:
	find man -type d -printf %P\\0 | xargs -0r -I__ install -d $(DESTDIR)$(mandir)/__
	find man -type f -name \*.[12345678] -printf %P\\0 | xargs -0r -I__ install -m644 man/__ $(DESTDIR)$(mandir)/__
	find man -type f -name \*.[12345678] -printf %P\\0 | xargs -0r -I__ gzip $(DESTDIR)$(mandir)/__

install-sysconf:
	find etc -type d -printf %P\\0 | xargs -0r -I__ install -d $(DESTDIR)$(sysconfdir)/__
	find etc -type f -not -name freight.conf -printf %P\\0 | xargs -0r -I__ install -m644 etc/__ $(DESTDIR)$(sysconfdir)/__

man:
	find man -name \*.ronn | xargs -n1 ronn --manual=Freight --style=toc

docs:
	for SH in $$(find bin lib -type f -not -name \*.html); do \
		shocco $$SH >$$SH.html; \
	done


.PHONY: all install man
