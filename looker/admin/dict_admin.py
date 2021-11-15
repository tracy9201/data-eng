import looker_sdk

from looker_sdk.sdk.api40.models import LookmlModelNavExplore

sdk = looker_sdk.init40(config_file="looker.ini", section="Looker")

def get_explore(model_name, explore_name):
    explore = sdk.lookml_model_explore(
        lookml_model_name=model_name,
        explore_name=explore_name,
        fields="id, name, description, fields",
    )
    return explore


def get_field_values(model_name, explore_name):
    # API Call to pull in metadata about fields in a particular explore
    explore = get_explore(model_name, explore_name)
    my_fields = []
    print(explore.id)
    # Iterate through the field definitions and pull in the description, sql,
    # and other looker tags you might want to include in  your data dictionary.
    if explore.fields and explore.fields.dimensions:
        for dimension in explore.fields.dimensions:
            dim_def = {
                "field_type": "Dimension",
                "view_name": dimension.view_label,
                "field_name": dimension.label_short,
                "type": dimension.type,
                "description": dimension.description,
                "sql": dimension.sql,
            }
            my_fields.append(dim_def)
    if explore.fields and explore.fields.measures:
        measure = explore.fields.get('measures')
        for i,item in enumerate(measure):
            print(item)
            if item==123:
                print(measure[i])
                break
        #explore.fields.update(measure=updated_measure)
        for measure in explore.fields.measures:
            mes_def = {
                "field_type": "Measure",
                "view_name": measure.view_label,
                "field_name": measure.label_short,
                "type": measure.type,
                "description": measure.description,
                "sql": measure.sql,
            }
            my_fields.append(mes_def)
    return my_fields

#test of function
get_field_values('opul_merchant_statement','fact_merch_stmt_deposit_summary')

field_name = 'fact_merch_stmt_deposit_summary.adjustments'

field_params = {'description':'Description of adjustment','sql':'None'}

def update_field_measure(model_name, explore_name, field_name, **field_params):
    explore = get_explore(model_name, explore_name)
    if explore.fields and explore.fields.measures:
        measure = explore.fields.get('measures')
        print(explore.fields.keys())
        new_measures = []
        for i, item in enumerate(measure):
            print(item.get('name'))
            if item.get('name')==field_name:
                if 'description' in field_params:
                    item.update(description=field_params.get('description'))
                if 'sql' in field_params:
                    pass
                print(item)
                print('Measure {} is updated with following values {}'.format(field_name, field_params))
                break
            new_measures.append(item)
        explore.fields.update(measures = new_measures)


update_field_measure(model_name='opul_merchant_statement', 
    explore_name='fact_merch_stmt_deposit_summary',
    field_name='fact_merch_stmt_deposit_summary.adjustments',
    **field_params)


help(sdk.lookml_model('opul_merchant_statement').get('explores'))



explore = get_explore(model_name='opul_merchant_statement', 
    explore_name='fact_merch_stmt_deposit_summary')
item = LookmlModelExplore(explore)

explores = sdk.lookml_model('opul_merchant_statement').get('explores')
len(explores)

new_explores = []

for i, item in enumerate(sdk.lookml_model('opul_merchant_statement').get('explores')):
    print(item.get('name'))
    if item.get('name') == 'fact_merch_stmt_deposit_summary':
        new_explores.append(explore)
    else:
        new_explores.append(explores.pop(0))
    type(new_explores)

for i, item in enumerate(new_explores):
    print(i, item)

sdk.update_lookml_model()