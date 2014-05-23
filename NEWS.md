## 0.3.2 (2014-05-23)

* Fix bypassing of SSL verification using cURL (thanks @xsk)

## 0.3.1 (2014-05-21)

* Ensure gemspec dependencies are properly set for Cap ~> 3.2.1

## 0.3.0 (2014-05-21) (unpublished)

* Refactor to be compatible with Capistrano ~> 3.2

## 0.2.0 (2014-03-06)

* Allow unstable, but successful, builds to deploy
* Tweak "no green builds" message to not use higher-byte character

## 0.1.0 (2014-02-11)

* Initial version for Capistrano 3
    * Removes certain features:
        * `:jenkins_use_unstable`
        * `:jenkins_scm_log_prefix`

## 0.0.8 (2013-12-29)

* [#11] filter scm log with prefix

## 0.0.7 (2013-10-28)

* [#9] fix crash on strange title

## 0.0.6 (2013-03-19)

* [#1, #7] support https  (thanks @lostintime)

## 0.0.5 (2013-01-31)

* works under Windows (thanks @Iristyle)

## 0.0.4 (2012-06-21)

* working with non-English server (thanks cynipe).

## 0.0.3 (2011-12-13)

* support netrc

## 0.0.2 (2011-11-26)

* honor :scm_username and :scm_password
* fix syntax bug under ruby 1.9

## 0.0.1 (2011-11-25)

* initial version.
