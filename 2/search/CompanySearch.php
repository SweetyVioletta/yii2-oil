<?php
namespace medicine\models\search;

use medicine\models\Company;
use yii\data\ActiveDataProvider;

class CompanySearch extends Company
{
    /** @var ActiveQuery */
    public $query;
    public $perPage = 20;

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['id', 'slug', 'name', 'person'], 'safe'],
        ];
    }

    /**
     * Creates data provider instance with search query applied
     *
     * @param array $params
     *
     * @return ActiveDataProvider
     */
    public function search($params)
    {
        $query = $this->query;
        if (!$query) {
            $query = static::find();
        }

        $query->joinWith('companyPersons cp');
        $query->addSelect([
            'personCount' => 'COUNT(cp.personId)'
        ])
            ->groupBy(static::tableName() . '.id');

        // add conditions that should always apply here

        $dataProvider = new ActiveDataProvider([
            'query' => $query,
            'pagination' => [
                'pageSize' => $this->perPage,
            ],
            'sort' => [
                'attributes' => [
                    'sortOrder',
                    'personCount'
                ]
            ]
        ]);

        $this->load($params);

        if (!$this->validate()) {
            // uncomment the following line if you do not want to return any records when validation fails
            // $query->where('0=1');
            return $dataProvider;
        }
        $query->andFilterWhere([
            'id' => $this->id,
        ]);
        $query->andFilterWhere([
            'LIKE',
            'slug',
            $this->slug,
            false
        ]);
        $query->andFilterWhere([
            'LIKE',
            'name',
            $this->name,
            false
        ]);
        // filter by person name
        if (is_int($this->person)){ // person is a id of model
            $query->andWhere(['personId' => $this->person]);
        } elseif (is_string($this->person)) { // person include part on model name
            $query->joinWith('persons p');
            $query->andWhere(['LIKE', 'p.name', '%' . $this->person. '%', false]);
        }
        return $dataProvider;
    }
}
