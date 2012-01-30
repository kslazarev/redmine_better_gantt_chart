module RedmineBetterGanttChart
  module IssuePatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      # Defines whether this issue is marked as external from the current project
      def external=(flag)
        @external = flag
      end

       # Returns whether this issue is marked as external from the current project
      def external?
        !!@external
      end

      def simple?
        !Issue.find(:first, :conditions => ["parent_id = ?", id])
      end

      def complete_in_time?
        complete_date <= due_date
      end

      def miss_time
        due_date - complete_date.to_date
      end
    end
  end
end
