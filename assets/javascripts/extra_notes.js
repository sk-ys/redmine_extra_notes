(function () {
  "use strict";

  var types = [];

  function findTypeByTabName(tabName) {
    return types.find(function (type) {
      return "extra_notes_" + type.key === tabName;
    });
  }

  function findTypeById(noteTypeId) {
    return types.find(function (type) {
      return type.id === noteTypeId;
    });
  }

  function refreshHistoryTab() {
    $('#history .tabs a[id^="tab-extra_notes_"]').each(function (_, el) {
      var tabName = el.id.replace("tab-extra_notes_", "");
      var type = types.find(function (candidate) {
        return candidate.key === tabName;
      });

      if (
        type &&
        $("#tab-content-history").find(
          '.journal:has(.extra-notes-label[data-note-type="' + type.id + '"])',
        ).length > 0
      ) {
        el.style.display = "";
      } else {
        el.style.display = "none";
      }
    });
  }

  function showTabForNoteType(noteTypeId) {
    if (!noteTypeId) {
      $("#history .tabs #tab-notes").trigger("click");
      return;
    }

    var type = findTypeById(noteTypeId);
    if (type) {
      $("#history .tabs #tab-extra_notes_" + type.key).trigger("click");
    }
  }

  function init(extraNoteTypes) {
    types = extraNoteTypes || [];

    if (
      typeof window.showIssueHistory !== "function" ||
      !window.showIssueHistory.extraNotesWrapped
    ) {
      var originalShowIssueHistory = window.showIssueHistory || function () {};

      window.showIssueHistory = function (journal, url) {
        var extraTab = findTypeByTabName(journal);

        if (extraTab) {
          originalShowIssueHistory("notes", url);
          $("#tab-content-history")
            .parent()
            .find(".tabs a")
            .removeClass("selected");
          $("#tab-extra_notes_" + extraTab.key).addClass("selected");
        } else {
          originalShowIssueHistory(journal, url);
        }

        if (journal === "notes") {
          types.forEach(function (type) {
            $("#tab-content-history")
              .find(
                '.journal:has(.extra-notes-label[data-note-type="' +
                  type.id +
                  '"])',
              )
              .hide();
          });
        } else if (extraTab) {
          $("#tab-content-history")
            .find(
              '.journal:not(:has(.extra-notes-label[data-note-type="' +
                extraTab.id +
                '"]))',
            )
            .hide();
        }

        return false;
      };

      window.showIssueHistory.extraNotesWrapped = true;
    }

    refreshHistoryTab();
  }

  window.extraNotes = {
    init: init,
    refreshHistoryTab: refreshHistoryTab,
    showTabForNoteType: showTabForNoteType,
  };
})();
