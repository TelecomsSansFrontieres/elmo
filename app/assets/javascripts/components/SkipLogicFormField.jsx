class SkipLogicFormField extends React.Component {
  constructor(props) {
    super();
    let skip = props.skip_rules.length == 0 ? 'dont_skip' : 'skip';
    this.state = Object.assign({}, props, {skip: skip});
    this.skipOptionChanged = this.skipOptionChanged.bind(this);
  }

  skipOptionChanged(event) {
    this.setState({skip: event.target.value});
  }

  render() {
    let select_props = {
      className: "form-control skip-or-not",
      value: this.state.skip,
      onChange: this.skipOptionChanged
    };

    return (
      <div>
        <select {...select_props}>
          <option value="dont_skip">{I18n.t('form_item.skip_logic_options.dont_skip')}</option>
          <option value="skip">{I18n.t('form_item.skip_logic_options.skip')}</option>
        </select>
        <SkipRuleSetFormField hide={this.state.skip == "dont_skip"} {...this.state} />
      </div>
    );
  }
}
