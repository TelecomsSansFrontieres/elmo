# Class responsible to reorganize the questions
# It's main concern is to separate a qing group that contains multilevel
# questionings into several groups. The idea here is to just remove the
# multilevel questioning from the group, since ODK doesn't show it correctly
# if it's a child of a group.
#
# Input:
#  QingGroup qgroup
#     with children: Qing1, Qing2, MultilevelQing, Qing3
# Output:
#  [ QingGroupFragment with children Qing1 and Qing2,
#    QingGroupFragment with child MultilevelQing,
#    QingGroupFragment with child Qing3
#   ]
#
class QingGroupOdkPartitioner

  def fragment(qing_group)
    result = nil
    if eligible_for_partition(qing_group)
      result = split_qing_group_as_necessary(qing_group)
    end
    result
  end

  private

  def eligible_for_partition(qing_group)
    qing_group.children.count > 1 &&
      qing_group.sorted_children.none? { |child| child.is_a?(QingGroup) } &&
      qing_group.children.any?(&:multilevel?)
  end

  def split_qing_group_as_necessary(qing_group)
    result = []
    temp_group_children = []
    qing_group.sorted_children.each do |child|
      if child.multilevel?
        result << QingGroupFragment.new(qing_group, temp_group_children)
        result << QingGroupFragment.new(qing_group, [child])
        temp_group_children = []
      else
        temp_group_children << child
      end
    end
    result << QingGroupFragment.new(qing_group, temp_group_children) unless temp_group_children.empty?
    result
  end
end
