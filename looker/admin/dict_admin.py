import looker_sdk
import pandas as pd

import datetime
from atlassian import Confluence  
import requests
import logging
from looker_sdk.sdk.api40 import models as ml
from looker_sdk.sdk.api40.models import LookmlModelNavExplore


sdk = looker_sdk.init40(config_file="looker.ini", section="Looker")


#function for getting explore
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

explore = get_explore(model_name='opul_merchant_statement', 
    explore_name='fact_merch_stmt_deposit_summary')
item = LookmlModelExplore(explore)

explores = sdk.lookml_model('qa-dashboard').get('explores')
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

sdk.create_lookml_model(
                ml.WriteLookmlModel(
                    name='test-looker-sdk',
                    project_name='qa-dashboard-staging'
                )
            )

df = pd.DataFrame()




confluence = Confluence(
    url='https://hintmd.atlassian.net/',
    username='yurii.kosovskyi@revance.com',
    password='zdegsshCWXldqXWriF8K16B9',
    cloud=True)

status = confluence.update_page(  
    parent_id=None,
    title='OPUL dictionaries', 
    page_id=confluence.get_page_by_title(space='DevOps', title='OPUL dictionaries').get('id'), # These are names that you have used while creating page  
    body='Dictionaries were updated at: {}'.format(datetime.datetime.now())) # Here you can put the content by using HTML tags. 
print(status)

for i in sdk.all_lookml_models():
    model = i.get('name')
    body = ''
    if len(i.get('explores')) > 0:
        for expl in i.get('explores'):
            df = pd.DataFrame()
            #print(model, expl.get('name'))
            try:
                expl_name = expl.get('name')
                df = pd.DataFrame(get_field_values(model, expl_name))
                html_header = '<h2>{}</h2>'.format(expl_name)
                html = html_header + df.to_html()
                body = html + body
            except Exception as e:
                print("exception with getting dictionaries for Model {}, Explore {}.".format(model, expl.get('name')))
            # Below would update Confluence Page  
        try:
            status = confluence.create_page( 
                parent_id = confluence.get_page_by_title(space='DevOps', title='OPUL dictionaries').get('id'),
                space='DevOps',  
                title='Model {}'.format(model),  
                body=body
            ) # Here you can put the content by using HTML tags.  
            print(status)
        except Exception as e:
            status = confluence.update_page(  
                parent_id=confluence.get_page_by_title(space='DevOps', title='OPUL dictionaries').get('id'),
                title='Model {}'.format(model), 
                page_id=confluence.get_page_by_title(space='DevOps', title='Model {}'.format(model)).get('id'), # These are names that you have used while creating page  
                body=body) # Here you can put the content by using HTML tags. 
            print(status)

def main():
    looker_sdk = my_looker_sdk('qa')
    looker_sdk.get_look()


if __name__ == "__main__":
    
    main()


#example of using get values
#get_field_values('parameterized_opul_merchant_statement', 'sql_runner_query')